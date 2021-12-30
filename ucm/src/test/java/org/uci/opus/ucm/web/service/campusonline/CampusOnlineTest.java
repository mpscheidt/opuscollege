package org.uci.opus.ucm.web.service.campusonline;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import java.util.Arrays;

import org.dbunit.database.AmbiguousTableNameException;
import org.dbunit.dataset.DefaultDataSet;
import org.dbunit.dataset.DefaultTable;
import org.dbunit.dataset.IDataSet;
import org.dbunit.dataset.ITable;
import org.dbunit.util.fileloader.DataFileLoader;
import org.dbunit.util.fileloader.FlatXmlDataFileLoader;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;
import org.uci.opus.college.dbunit.OpusDBTestCase;
import org.uci.opus.college.web.util.JsonResponse;
import org.uci.opus.ucm.web.service.JsonResponseFactory;
import org.uci.opus.util.Encode;

/**
 * Note that in order to use the hamcrest-all.jar (which has the hamcrest matchers like hasSize())
 * it's important that the junit.jar does not interfere because it has also a hamcrest dependency.
 * 
 * In Eclipse this can be resolved by exporting hamcrest-all.jar before junit.jar.
 * 
 * @author Markus Pscheidt
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({
        "/standardTestBeans.xml",
        "/standardRestTestBeans.xml",
        "/org/uci/opus/college/applicationContext-data.xml",
        "/org/uci/opus/college/applicationContext-util.xml",
        "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/ucm/applicationContext.xml",
        "CampusOnlineTest-context.xml"
})
public class CampusOnlineTest extends OpusDBTestCase {
    private static final Logger LOG = LoggerFactory.getLogger(CampusOnlineTest.class);

    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Before
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
    }

    @Override
    protected IDataSet getDataSetToTruncateInSetup() throws AmbiguousTableNameException {
        IDataSet dataSetToTruncate = new DefaultDataSet(new ITable[] {
                new DefaultTable("opuscollege.endgrade"),
                new DefaultTable("opuscollege.examinationtype")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {

        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/ucm/web/service/campusonline/CampusOnlineTest-prepData.xml");
        return dataSet;
    }

    private String getURL(String studentCode) {
        String hash = Encode.encodeMd5(JsonResponseFactory.PRIVATE_KEY + studentCode);
        return getURL(studentCode, hash);
    }

    private String getURL(String studentCode, String hash) {
        String url = "/campusOnline/getResultsByStudentCode/" + studentCode + "/" + hash;
        LOG.info("URL: " + url);
        return url;
    }    

    private String getPhotographURL(String studentCode) {
        String hash = Encode.encodeMd5(JsonResponseFactory.PRIVATE_KEY + studentCode);
        return getPhotographURL(studentCode, hash);
    }

    private String getPhotographURL(String studentCode, String hash) {
        String url = "/campusOnline/getPhotographByStudentCode/" + studentCode + "/" + hash;
        LOG.info("Photograph URL: " + url);
        return url;
    }    

    @Test
    public void nonExistentStudentCode() throws Exception {
        String studentCode = "noValidStudentCode";
        this.mockMvc.perform(get(getURL(studentCode))
                .accept(MediaType.parseMediaType("application/json;charset=utf-8"))
                )
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=utf-8"))
                .andExpect(jsonPath("$.status").value(JsonResponse.FAILURE))
                .andExpect(jsonPath("$.result").value(JsonResponseFactory.INVALID_STUDENT_CODE));
    }

    @Test
    public void invalidHash() throws Exception {
        String studentCode = "12345";
        this.mockMvc.perform(get(getURL(studentCode, "wrongHash")))
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=utf-8"))
                .andExpect(jsonPath("$.status").value(JsonResponse.FAILURE))
                .andExpect(jsonPath("$.result").value(JsonResponseFactory.INVALID_HASH));
    }

    @Test
    public void student705120131() throws Exception {
        String studentCode = "705120131";
        this.mockMvc.perform(get(getURL(studentCode)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=utf-8"))
            .andExpect(jsonPath("$.status").value(JsonResponse.SUCCESS))
            
            .andExpect(jsonPath("$.result.surname").value("Tomo"))
            .andExpect(jsonPath("$.result.firstnames").value("Ailton Artur"))
            .andExpect(jsonPath("$.result.studentStatus").value("Activo"))
            .andExpect(jsonPath("$.result.latestTimeUnits", hasSize(1)))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].studyDescription").value("Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].gradeTypeDescription").value("Licenciatura"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].timeUnitNumber").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].progressStatus").value("Transitar (todas cadeiras aprovadas)"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results", hasSize(3)))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].creditAmount").value(2.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].mark").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].comment").value("Excluido"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].subResults").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].code").value("s2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].description").value("Saude Familiar 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].creditAmount").value(1.5))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].mark").value("9.2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].code").value("e1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].description").value("Nota Frequencia"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].mark").value("9.8"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[0].code").value("t1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[0].description").value("PBL session 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[0].mark").value("1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[1].code").value("t2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[1].description").value("PBL session 2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[1].mark").value("10"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[0].subResults[1].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[1].code").value("e3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[1].description").value("Final exam"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[1].mark").value("12"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[1].subResults[1].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].description").value("Interaccao e regulacao"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].creditAmount").value(1.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].mark").value("15.3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[2].subResults").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[3]").doesNotExist());
    }

    @Test
    public void student705120134() throws Exception {
        String studentCode = "705120134";
        this.mockMvc.perform(get(getURL(studentCode)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=utf-8"))
            .andExpect(jsonPath("$.status").value(JsonResponse.SUCCESS))
            .andExpect(jsonPath("$.result.surname").value("Ernesto"))
            .andExpect(jsonPath("$.result.firstnames").value("Aldivandia Da Merilia"))
            .andExpect(jsonPath("$.result.studentStatus").value("Falecido"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].studyDescription").value("Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].gradeTypeDescription").value("Mestrado"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].timeUnitNumber").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].progressStatus").value("Transitar e repetir"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].code").value("m1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].description").value("Cadeira do mestrado 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].creditAmount").value(3.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].mark").value("15.4"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].results[0].subResults").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].studyDescription").value("Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].gradeTypeDescription").value("Licenciatura"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].timeUnitNumber").value(5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].progressStatus").value(nullValue()))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].timeUnit").value(5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].creditAmount").value(2.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].mark").value("13.2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[0].subResults").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].code").value("s2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].description").value("Saude Familiar 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].timeUnit").value(5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].creditAmount").value(1.5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].mark").value("14.3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].subResults[0].code").value("e3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].subResults[0].description").value("Final exam"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].subResults[0].mark").value("15.5"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].subResults[0].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[1].subResults[1]").doesNotExist())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].results[2]").doesNotExist())
            .andExpect(jsonPath("$.result.latestTimeUnits[2]").doesNotExist());
    }

    @Test
    public void student705120131Photograph() throws Exception {

        // to illustrate, photograph byte data is "12345" and has been base64 encoded, e.g. in Postgres:
        //    select encode('12345', 'base64');    ---->    which results in:  "MTIzNDU="  (the string written in prep.xml)
        // see: http://stackoverflow.com/a/2108139/606662
        LOG.info("FYI: bytes of the image data are expected to be: " + (Arrays.toString("12345".getBytes())));

        String studentCode = "705120131";
        this.mockMvc.perform(get(getPhotographURL(studentCode)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("image/png"))
//            .andExpect(content().bytes(new byte[] { 106, -57, 95 }));
            .andExpect(content().bytes(new byte[] { 49, 50, 51, 52, 53 }))
            .andExpect(content().bytes("12345".getBytes()))
            ;
    }

}
