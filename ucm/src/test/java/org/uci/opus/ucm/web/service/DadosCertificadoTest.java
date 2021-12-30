package org.uci.opus.ucm.web.service;

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
import org.uci.opus.util.Encode;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration({
        "/standardTestBeans.xml",
        "/standardRestTestBeans.xml",
        "/org/uci/opus/college/applicationContext-data.xml",
        "/org/uci/opus/college/applicationContext-util.xml",
        "/org/uci/opus/college/applicationContext-service.xml",
        "/org/uci/opus/ucm/applicationContext.xml",
        "DadosCertificadoTest-context.xml"
})
public class DadosCertificadoTest extends OpusDBTestCase {
    private static final String MESTRE = "Mestre";

    private static final String LICENCIATURA = "Licenciatura";

    private static final String MEDICINA_GERAL = "Medicina Geral";

    private static final Logger LOG = LoggerFactory.getLogger(DadosCertificadoTest.class);

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
                new DefaultTable("opuscollege.studyplandetail")
        });
        return dataSetToTruncate;
    }

    @Override
    protected IDataSet getDataSet() throws Exception {

        // initialize your dataset here
        IDataSet dataSet = null;
        DataFileLoader loader = new FlatXmlDataFileLoader();
        dataSet = loader.load("/org/uci/opus/ucm/web/service/DadosCertificadoTest-prepData.xml");
        return dataSet;
    }

    private String getURL(String studentCode, String birthdate) {
        String hash = Encode.encodeMd5(JsonResponseFactory.PRIVATE_KEY + studentCode + birthdate);
        return getURL(studentCode, birthdate, hash);
    }

    private String getURL(String studentCode, String birthdate, String hash) {
        String url = "/dadosCertificado/" + studentCode + "/" + birthdate + "/" + hash;
        LOG.info("URL: " + url);
        return url;
    }    

    /**
     * If student code does not exist at all expect
     * {@link JsonResponseFactory#INVALID_STUDENT_CODE_OR_BIRTH_DATE}.
     * @throws Exception
     */
    @Test
    public void nonExistentStudentCode() throws Exception {
        String studentCode = "noValidStudentCode";
        String birthdate = "1970-01-01";
        this.mockMvc.perform(get(getURL(studentCode, birthdate))
                .accept(MediaType.parseMediaType("application/json;charset=utf-8"))
                )
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=utf-8"))
                .andExpect(jsonPath("$.status").value(JsonResponse.FAILURE))
                .andExpect(jsonPath("$.result").value(JsonResponseFactory.INVALID_STUDENT_CODE_OR_BIRTH_DATE));
    }

    /**
     * If birthdate does not match with the correct data of the given student,
     * expect same error message as if student code does not exist at all:
     * {@link JsonResponseFactory#INVALID_STUDENT_CODE_OR_BIRTH_DATE}.
     * @throws Exception
     */
    @Test
    public void birthDateMismatch() throws Exception {
        String studentCode = "705120131";
        String birthdate = "1970-01-01";
        this.mockMvc.perform(get(getURL(studentCode, birthdate))
                .accept(MediaType.parseMediaType("application/json;charset=utf-8"))
                )
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=utf-8"))
                .andExpect(jsonPath("$.status").value(JsonResponse.FAILURE))
                .andExpect(jsonPath("$.result").value(JsonResponseFactory.INVALID_STUDENT_CODE_OR_BIRTH_DATE));
    }

    /**
     * Invalid birth date (not in yyyy-MM-dd format) shall result in a HTTP status 400.
     * @throws Exception
     */
    @Test
    public void invalidBirthDate() throws Exception {
        String studentCode = "705120131";
        String birthdate = "197-ab-01";
        this.mockMvc.perform(get(getURL(studentCode, birthdate)))
                .andExpect(status().is(400));
    }

    @Test
    public void invalidHash() throws Exception {
        String studentCode = "12345";
        String birthDate = "1988-01-01";
        this.mockMvc.perform(get(getURL(studentCode, birthDate, "wrongHash")))
                .andDo(print())
                .andExpect(status().isOk())
                .andExpect(content().contentType("application/json;charset=utf-8"))
                .andExpect(jsonPath("$.status").value(JsonResponse.FAILURE))
                .andExpect(jsonPath("$.result").value(JsonResponseFactory.INVALID_HASH));
    }

    /**
     * Student with two graduated studies: LIC and MSC
     * @throws Exception
     */
    @Test
    public void student705120131() throws Exception {
        String studentCode = "705120131";
        String birthdate = "1981-12-17";
        this.mockMvc.perform(get(getURL(studentCode, birthdate)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=utf-8"))
            .andExpect(jsonPath("$.status").value(JsonResponse.SUCCESS))
            .andExpect(jsonPath("$.result[0].firstnames").value("Ailton Artur"))
            .andExpect(jsonPath("$.result[0].surname").value("Tomo"))
            .andExpect(jsonPath("$.result[0].graduated").value(Boolean.TRUE))
            .andExpect(jsonPath("$.result[0].mark").value("13"))
            .andExpect(jsonPath("$.result[0].study").value(MEDICINA_GERAL))
            .andExpect(jsonPath("$.result[0].degree").value(LICENCIATURA))
            .andExpect(jsonPath("$.result[1].firstnames").value("Ailton Artur"))
            .andExpect(jsonPath("$.result[1].surname").value("Tomo"))
            .andExpect(jsonPath("$.result[1].graduated").value(Boolean.TRUE))
            .andExpect(jsonPath("$.result[1].mark").value("12"))
            .andExpect(jsonPath("$.result[1].study").value(MEDICINA_GERAL))
            .andExpect(jsonPath("$.result[1].degree").value(MESTRE))
            .andExpect(jsonPath("$.result[2]").doesNotExist());
    }

    /**
     * Student with one graduated (LIC) and one active, but non-graduated study (MSC)
     * @throws Exception
     */
    @Test
    public void student705120134() throws Exception {
        String studentCode = "705120134";
        String birthdate = "1979-01-29";
        this.mockMvc.perform(get(getURL(studentCode, birthdate)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=utf-8"))
            .andExpect(jsonPath("$.status").value(JsonResponse.SUCCESS))
            .andExpect(jsonPath("$.result[0].firstnames").value("Aldivandia Da Merilia"))
            .andExpect(jsonPath("$.result[0].surname").value("Ernesto"))
            .andExpect(jsonPath("$.result[0].graduated").value(Boolean.TRUE))
            .andExpect(jsonPath("$.result[0].mark").value("14"))
            .andExpect(jsonPath("$.result[0].study").value(MEDICINA_GERAL))
            .andExpect(jsonPath("$.result[0].degree").value(LICENCIATURA))
            .andExpect(jsonPath("$.result[1]").doesNotExist());
    }

    /**
     * Student with active, but non-graduated study (LIC)
     * @throws Exception
     */
    @Test
    public void student705120137() throws Exception {
        String studentCode = "705120137";
        String birthdate = "1988-07-14";
        this.mockMvc.perform(get(getURL(studentCode, birthdate)))
            .andDo(print())
            .andExpect(status().isOk())
            .andExpect(content().contentType("application/json;charset=utf-8"))
            .andExpect(jsonPath("$.status").value(JsonResponse.SUCCESS))
            .andExpect(jsonPath("$.result[0]").doesNotExist());
    }

}
