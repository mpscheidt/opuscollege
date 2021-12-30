package org.uci.opus.ucm.web.service.campusonline.fullresults;

import static org.hamcrest.Matchers.hasSize;
import static org.hamcrest.Matchers.nullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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
        "CampusOnlineGetFullResultsTest-context.xml"
})
public class CampusOnlineGetFullResultsTest extends OpusDBTestCase {

    private static final Logger LOG = LoggerFactory.getLogger(CampusOnlineGetFullResultsTest.class);

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
        dataSet = loader.load("/org/uci/opus/ucm/web/service/campusonline/fullresults//CampusOnlineGetFullResultsTest-prepData.xml");
        return dataSet;
    }

    private String getURL(String studentCode) {
        String hash = Encode.encodeMd5(JsonResponseFactory.PRIVATE_KEY + studentCode);
        return getURL(studentCode, hash);
    }

    private String getURL(String studentCode, String hash) {
        String url = "/campusOnline/getFullResultsByStudentCode/" + studentCode + "/" + hash;
        LOG.info("URL: " + url);
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
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects", hasSize(3)))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].creditAmount").value(2.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].mark").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].comment").value("Excluido"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].code").value("s2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].description").value("Saude Familiar 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].creditAmount").value(1.5))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].code").value("s2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].description").value("Saude Familiar 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].mark").value("9.2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[0].comment").isEmpty())
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[1].code").value("e1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[1].description").value("Nota Frequencia"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[1].mark").value("9.8"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[1].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[2].code").value("t1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[2].description").value("PBL session 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[2].mark").value("1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[2].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[3].code").value("t2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[3].description").value("PBL session 2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[3].mark").value("10"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[3].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[4].code").value("e3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[4].description").value("Final exam"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[4].mark").value("12"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[1].results[4].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].code").value("s3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].description").value("Interaccao e regulacao"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].creditAmount").value(1.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].results[0].code").value("s3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].results[0].description").value("Interaccao e regulacao"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].results[0].mark").value("15.3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[2].results[1]").doesNotExist());
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
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].code").value("m1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].description").value("Cadeira do mestrado 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].creditAmount").value(3.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].code").value("m1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].description").value("Cadeira do mestrado 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].timeUnit").value(1))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].mark").value("15.4"))
            .andExpect(jsonPath("$.result.latestTimeUnits[0].subjects[0].results[0].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].studyDescription").value("Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].gradeTypeDescription").value("Licenciatura"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].timeUnitNumber").value(5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].progressStatus").value(nullValue()))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].creditAmount").value(2.0))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].results[0].code").value("s1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].results[0].description").value("Introducao a Medicina"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].results[0].timeUnit").value(5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].results[0].mark").value("13.2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[0].results[0].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].code").value("s2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].description").value("Saude Familiar 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].creditAmount").value(1.5))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[0].code").value("t1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[0].description").value("PBL session 1"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[0].mark").value("2"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[0].passed").value(false))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[1].code").value("e3"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[1].description").value("Final exam"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[1].mark").value("15.5"))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[1].passed").value(true))
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[1].results[2]").doesNotExist())
            .andExpect(jsonPath("$.result.latestTimeUnits[1].subjects[2]").doesNotExist())
            .andExpect(jsonPath("$.result.latestTimeUnits[2]").doesNotExist());
    }

}
