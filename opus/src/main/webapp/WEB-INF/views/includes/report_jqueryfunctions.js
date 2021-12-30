/*
***** BEGIN LICENSE BLOCK *****
Version: MPL 1.1/GPL 2.0/LGPL 2.1

The contents of this file are subject to the Mozilla Public License Version 
1.1 (the "License"); you may not use this file except in compliance with 
the License. You may obtain a copy of the License at 
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
for the specific language governing rights and limitations under the
License.

The Original Code is Opus-College report module code.

The Initial Developer of the Original Code is
Center for Information Services, Radboud University Nijmegen
and Universidade Catolica de Mocambique.
Portions created by the Initial Developer are Copyright (C) 2008
the Initial Developer. All Rights Reserved.

Contributor(s):
  For Java files, see Javadoc @author tags.

Alternatively, the contents of this file may be used under the terms of
either the GNU General Public License Version 2 or later (the "GPL"), or
the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
in which case the provisions of the GPL or the LGPL are applicable instead
of those above. If you wish to allow use of your version of this file only
under the terms of either the GPL or the LGPL, and not to allow others to
use your version of this file under the terms of the MPL, indicate your
decision by deleting the provisions above and replace them with the notice
and other provisions required by the GPL or the LGPL. If you do not delete
the provisions above, a recipient may use your version of this file under
the terms of any one of the MPL, the GPL or the LGPL.

***** END LICENSE BLOCK *****
*/
 <script type="text/javascript">

  
/**
    author:Stelio Macumbe - May 19 , 09
    Retrieves an array of JSON's from an URL
    Creation of JSON objects is up to the server side application that responds for the specified URL 

    @param url - the URL from which request an array of JSON objects , parameters are specified using a querystring . e.g. http://eSura.com?param1=one&param2=2
    @return - list of JSON objects
    
 */
    /*
    function getJSONList(url){

        var JSONList ;
         
                jQuery.getJSON(url , function(data){
                    JSONList = data;   
                });

            return JSONList;
    }*/

 /**
    author:Stelio Macumbe - May 19 , 09
    Updates table with a list of JSON objects

    @param tableId - the id of the table that must be updated
    @param cols - the properties in the JSON object that will be displayed in the table
                   The properties names must be separated by commas
    @param data - an array of JSON objects that will be added to the table , every object is a row in the table
    
 */
    function updateTable(tableId , cols , data){
        var table = jQuery(tableId);
        var rows = "";
        var tRows = table.rows;
        var props = cols.split(",");

        //deletes every row but the header row
        for(i = 1; i < tRows.length; i++){
            table.deleteRow(i);
        }
        
        for(var i = 0 ; i < data.length; i++){
            rows += "<tr>";
            var obj = data[i];

            //add each property of current object to each cell in current row
            for(var j = 0 ; j < props.length; j++){
               var propertyName = cols[j];
                rows += "<td>" + obj[propertyName] + "</td>";                       
            }

            rows += "</tr>";
        }

        table.innerHTML += rows;
     
    }



    /**
    author:Stelio Macumbe - May 19 , 09
    Updates a table with a list of JSON objects created loaded by the following URL.
    Creation of JSON objects is up to the server side application that responds for the specified URL 

    @param url - the URL from which request an array of JSON objects , parameters are specified using a querystring . e.g. http://eSura.com?param1=one&param2=2
    @param tableId - the id of the table that must be updated
    @param cols - the properties in the JSON object that will be displayed in the table
                   The properties names must be separated by commas
    
    
 */
   
    function ajaxUpdateTable(url, tableId, cols) {
                
        jQuery.getJSON(url, function(data) {

            updateTable(tableId , cols , data[1]);
        });
        
    }

    /**
    author:Stelio Macumbe - May 19 , 09
    Updates selects with a list of JSON objects

    @param selectId - the id of the select that must be updated
    @param valueProperty -specifies what property in the JSON object will set the value attribute in the select options
    @param labelProperty -specifies what property in the JSON object will set label in the select options
    @param data - an array of JSON objects that will be added to the select , every object is a row in the select
    
     */
    function updateSelect(selectId, valueProperty, labelProperty, data) {

        var elementId = "select#" + selectId;
        var options = '<option value="0" selected="selected"><fmt:message key="jsp.selectbox.choose"/></option>';

        for ( var i = 0; i < data.length; i++) {
            var obj = data[i];
            options += '<option value="' + obj[valueProperty] + '">'
                    + obj[labelProperty] + '</option>';

        }

        jQuery(elementId).html(options);

    }

    /**
    author:Stelio Macumbe - May 19 , 09
    Updates a select with a list of JSON objects created loaded by the following URL.
    Creation of JSON objects is up to the server side application that responds for the specified URL 

    @param url - the URL from which request an array of JSON objects , parameters are specified using a querystring . e.g. http://eSura.com?param1=one&param2=2
    @param selectId - the id of the select that must be updated
    @param valueProperty -specifies what property in the JSON object will set the value attribute in the select options
    @param labelProperty -specifies what property in the JSON object will set label in the select options
    @param data - an array of JSON objects that will be added to the select , every object is a row in the select
    
     */
    function ajaxUpdateSelect(url, selectId, valueProperty, labelProperty) {
        displayLoad(selectId);
        jQuery.getJSON(url, function(data) {

            updateSelect(selectId, valueProperty, labelProperty, data[1]);
            removeLoad();
        });
    }

    /**
     *   author:Stelio Macumbe - May 21 , 09
     *
     *   Finds what fields should be used for value and for a label in a select option
     *   The first elent of the return array is the value and the second the label
     */

    function getFieldsForSelect(selectId) {

        var option0 = '<option value="0" selected="selected"><fmt:message key="jsp.selectbox.choose"/></option>';
        var selects = new Array("institutionId", "branchId", "organizationalUnitId", "studyId", 
                "academicYearId", "studyGradeTypeId", "subjectBlockId");
        var fields = new Array(2);

        switch (selectId) {
        case "institutionId":
            fields[0] = "id";
            fields[1] = "institutionDescription";
            break;
        case "branchId":
            fields[0] = "id";
            fields[1] = "branchDescription";
            break;
        case "organizationalUnitId":
            fields[0] = "id";
            fields[1] = "organizationalUnitDescription";
            break;
        case "studyId":
            fields[0] = "id";
            fields[1] = "studyDescription";
            break;
        case "academicYearId":
            fields[0] = "id";
            fields[1] = "description";
            break;
        case "studyGradeTypeId":
            fields[0] = "id";
            fields[1] = "gradeTypeDescription";//TO DO label should be studyDescription + gradeTypeDescription 
            break;
        case "subjectBlockId":
            fields[0] = "id";
            fields[1] = "subjectBlockDescription";
            break;
        }

        return fields;
    }

    /**
     * author:Stelio Macumbe - May 21 , 09
     *
     *Updates a hirearchy of select.e.g If a user changes an institution than all the selects (logically) below the institution select
     *as is branch , studyYear ,etc must either change their values or be set to 0 
     *
     *@param selectsIds - an array containing the ids with the select fields
     *@param selectId - the id of the select that is requesting for un hierarchy update
     *@param url - the url from where selects to be updated will retrieve values
     *@param smartLoading - a boolean value that tells if a select in a lower level of the hierarchy 
     *should be automatically updated if the select in the higher level as only a single value 
     *Note: The order the selects are added in the array reflects the selects hierarchy 
     *In case that one must be already
     */
    function updateSelectHierarchy(selectsIds , selectId, url , smartLoading) {

        var option0 = '<option value="0" selected="selected"><fmt:message key="jsp.selectbox.choose"/></option>';
        
        var fields = new Array(2);
        var selectValue = jQuery("select#" + selectId).val();
        //search for selectId in the array//the select in a level below (which is the next in the array) will be updated with values
        for (i = 0; i < selectsIds.length; i++) {
            
            //when found update the state of the other selects
            if (selectId == selectsIds[i]) {
                //if the specified select is being set to zero then all the selects in lower levels must
                //also be set to zero 
                //if it is not being set to zero then
                //the select in a level below (which is the next in the array) will be updated with values
                if ((selectValue != 0) && (selectValue != '0')) {
                    //check if the select of id selectId is not the last in the hierarchcy
                    //if it is then there is no need for updating the next lower select
                    if(i < (selectsIds.length - 1)){
                        i++;//move the index to the select in a level below
                        fields = getFieldsForSelect(selectsIds[i]);
                        ajaxUpdateSelect(url, selectsIds[i], fields[0], fields[1]);
                    }
                }
                //set the selects in lower levels to the default value
                for (++i; i < selectsIds.length; i++) {

                    jQuery("select#" + selectsIds[i]).html(option0);

                }
                //no need for keep looking as it was already found        
                break;
            }
        }

    }

    /*
    *Builds a query string given an array of ids
    *@param ids array with ids of elements from which build the querystring
    @param extraParams : additional params to be added to query string in the format paramName=paramValue&paramName2=paramValue2 etc
    *Note: Elements must have name attribute
    *
    */

    function buildQueryStringById(ids, extraParams) {

        var queryString = "";


        if ((ids != undefined) && (ids != null)) {
            //ignore fields which are disabled or unchecked
            for (i = 0; i < ids.length; i++) {
                var element = jQuery("#" + ids[i]).not(
                        ":disabled , [checked=false]");
                var name = jQuery.trim(element.attr("name"));
                var value = element.val();

                /*
                 do not append to the query string
                 elements which should not have "zeroed" values but have "zeroed" values
                 i.e. Elements which should not have "zeroed" values must belong to the class not0
                 */
                if ((!element.hasClass("not0"))
                        || (element.hasClass("not0") && value != "0")) {

                    if ((name != undefined) && (name != "")) {
                        queryString += "&" + name + "=" + value;

                    } else if (name == undefined) {

                        throw "Elements with id \"" + paramClass
                                + "\" must have name attribute" + "\r\n"
                                + "Check where it reads " + element.html();
                    } else if (name == "") {
                        throw "Name attribute should not be empty" + "\r\n"
                                + "Check where it reads " + element.html();
                    }
                }
            }
        }

        if (extraParams != undefined)
            queryString += "&" + jQuery.trim(extraParams);

        return queryString;
    }

    /**
     @author : Stelio Macumbe
     @date : September 05 , 2009
     @param paramClass : Specifies the class of elements from which to build the query string
     @param extraParams : additional params to be added to query string in the format paramName=paramValue&paramName2=paramValue2 etc
     Builds a query string based on the a specified class
     Every element with the specified class will have its name and value added to the query string
     Note: elements must have name attribute 
     **/
    function buildQueryString(paramClass, extraParams) {

        var queryString = "";

        if ((paramClass != undefined))
              paramClass = jQuery.trim(paramClass);
         
        if ((paramClass != undefined) && (paramClass != "")) {
            //ignore fields which are disabled or unchecked
            jQuery("." + paramClass).not(":disabled , [checked=false]").each(
                    function(index) {

                        var element = jQuery(this);
                        var name = jQuery.trim(element.attr("name"));
                        var id = element.attr("id");
                        var value = element.val();

                        /*
                         do not append to the query string
                        elements which should not have "zeroed" values but have "zeroed" values
                        i.e. Elements which should not have "zeroed" values must belong to the class not0
                         */
                        if ((!element.hasClass("not0"))
                                || (element.hasClass("not0") && (value != "0"))) {

                            if ((name != undefined) && (name != "")) {
                                queryString += "&" + name + "=" + value;

                            } else if (name == undefined) {

                                throw "Elements of class \"" + paramClass
                                        + "\" must have name attribute" + "\r\n"
                                        + "Check where it reads " + element.html();
                            } else if (name == "") {
                                throw "Name attribute should not be empty" + "\r\n"
                                        + "Check where it reads " + element.html();
                            }

                        }

                    });
        }

        if ((extraParams != undefined) && (extraParams != null))
            queryString += "&" + jQuery.trim(extraParams);

        return queryString;
    }


    /**
     * @author Stelio Macumbe
     * @date May 26 , 2009 
     *
     *Displays the loading image in front of the element with the specified id 
     *Note: it only works if the element is the last within its parent
     */

    function displayLoad(elementId) {
        var parentTag = jQuery("#" + elementId).parent();
        var isrc = '<c:url value="/images/loading.gif" />';
        var loadingImage = '<img id="loadImage" src=\'' + isrc + '\'/>';

        parentTag.append(loadingImage);

    }

    function displayLoad2(elementId) {
        var element = jQuery("#" + elementId);
        var isrc = '<c:url value="/images/loading.gif" />';
        var loadingImage = '<img id="loadImage" src=\'' + isrc + '\'/>';

        element.append(loadingImage);

    }

    function removeLoad() {
        jQuery("#loadImage").remove();
    }

    /**
     *Updates the paging footer in a table e.g  : "total number of student: 17  page 1 of 1" 
     *@param url - the url that a page number (which happens to be a link) will lead to
     *@param numberOfpages - number of pages label to be displayed in the table footer
     *@param currentPage - currentPage label to be displayed in footer
     *@param numberOfItems - total number of items label to be displayed in footer
     */
    function updatePaging(url, numberOfPages, currentPage, numberOfItems) {

        var pagingSpan = jQuery("span#paging");
        var pagingFooter = "<fmt:message key='jsp.general.totalnumberofitems' /> : "
                + numberOfItems
                + " <fmt:message key='jsp.general.page' /> "
                + currentPage
                + " <fmt:message key='jsp.general.of' /> "
                + numberOfPages;

        var pagingLinks = "&nbsp;";

        for (i = 1; i < numberOfPages; i++) {
            var pageLink = "<a href='" + url + "?pageNumber=" + i + "'>" + i
                    + "</a>";

            if (i == currentPage) {
                pagingLinks = pagingLinks + i;
            } else {
                pagingLinks = pagingLinks + pageLink;
            }
            pagingLinks = pagingLinks + "&nbsp;&nbsp;";

        }

        pagingFooter = pagingFooter + " " + pagingLinks;

        pagingSpan.html(pagingFooter);
    }

    function updateRowColor() {
        jQuery("tr").each( function(i) {

            alert(this.className);

        });

    }

    /**
     *@author Stelio Macumbe - May 20 , 2009
     *
     **/

    //this function is based in the alternate(id,rollover) in the function.js file
    function alternate2(id, rollover) {
        if (document.getElementsByTagName) {
            var table = document.getElementById(id);
            var rows = table.getElementsByTagName("tr");

            for (i = 0; i < rows.length; i++) {
                //manipulate only rows with no <th>
                var headers = rows[i].getElementsByTagName("th");
                if (headers.length == 0) {
                    if (i % 2 == 0) {
                        rows[i].className = "even";
                        if (rollover) {
                            rows[i].style.cursor = 'pointer';

                            rows[i].onmouseover = function() {
                                if (this.className != 'selectedRow') {
                                    this.className = 'ruled';
                                } else {
                                    this.className = 'selectedRowHover';
                                }
                                return false;

                            }
                            rows[i].onmouseout = function() {
                                if ((this.className != 'selectedRowHover')
                                        && (this.className != 'selectedRow')) {
                                    this.className = 'even';
                                } else {
                                    this.className = 'selectedRow';
                                }
                                return false;

                            }

                            rows[i].onclick = function() {

                                if (this.className == 'selectedRowHover') {
                                    this.className = 'even';
                                } else {
                                    this.className = 'selectedRow';
                                }

                                return false;
                            }
                        }
                    } else {
                        rows[i].className = "oneven";
                        if (rollover) {
                            rows[i].style.cursor = 'pointer';
                            rows[i].onmouseover = function() {
                                if (this.className != 'selectedRow') {
                                    this.className = 'ruled';
                                } else {
                                    this.className = 'selectedRowHover';
                                }
                                return false;

                            }
                            rows[i].onmouseout = function() {
                                if ((this.className != 'selectedRowHover')
                                        && (this.className != 'selectedRow')) {
                                    this.className = 'oneven';
                                } else {
                                    this.className = 'selectedRow';
                                }
                                return false;

                            }

                            rows[i].onclick = function() {

                                if (this.className == 'selectedRowHover') {
                                    this.className = 'even';
                                } else {
                                    this.className = 'selectedRow';
                                }

                                return false;
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     author:Stelio Macumbe
     date:June 25 , 09
     Sends a parameter to be saved in session

     @param url - the url that will handle the parameter saving
     @param name - the name to save
     @param value - the value to set 
     
     **/
    function ajaxSaveParam(url, name, value) {

        jQuery.ajax( {
            url :url,
            data :"ajax=true&operation=saveParam&param=" + name + "&value="
                    + value,
            success : function(msg) {

            }
        });
    }

    /**
     author:Stelio Macumbe
     date: September 2 , 2009
     Creates a report 
     The URL that will create URL
     Every element which has a class of reportParam will have its value name and value added
     as parameter 
     **/

    function createReport(baseURL, classesList , extraParams) {

        var queryString = "?ajax=true&operation=makereport";
        var classesArray = classesList.split(",");
        var classesString = "";

        for(var i = 0 ; i < classesArray.length; i++) {
            classesString += "." + jQuery.trim(classesArray[i]);
            //alert("i");
            //only append a comma if it is not the last element
            if((i + 1) != classesArray.length)
                classesString += ",";                
        }

        if((baseURL == undefined) || (baseURL == null) 
                || (jQuery.trim(baseURL) == "")) {
            throw "Empty report URL";
            return;
        }
        
        
        if ((baseURL != undefined) && (baseURL != "")) {
            //ignore fields which are disabled or unchecked
            
            jQuery(classesString).not(":disabled , [checked=false]").each(
                    function(index) {
                        
                        var element = jQuery(this);
                        var name = jQuery.trim(element.attr("name"));
                        var id = element.attr("id");
                        var value = element.val();

                        /*
                         do not append to the query string
                        elements which should not have "zeroed" values but have "zeroed" values
                        i.e. Elements which should not have "zeroed" values must belong to the class not0
                         */
                        if ((!element.hasClass("not0"))
                                || (element.hasClass("not0") && (value != "0"))) {

                            if ((name != undefined) && (name != "")) {

                                //report query elements must be prefixed with "where."
                                //so the ReportController knows they are meant to be part of
                                 //the report SQL
                                if(element.hasClass("reportQuery")){
                                    queryString += "&where." + name + "=" + value;
                                } else {
                                    queryString += "&" + name + "=" + value;
                                }
                                

                            } else if (name == undefined) {

                                throw "Elements of class \"reportParam\""
                                        + " must have name attribute" + "\r\n"
                                        + "Check where it reads " + element.html();
                            } else if (name == "") {
                                throw "Name attribute should not be empty" + "\r\n"
                                        + "Check where it reads " + element.html();
                            }

                        }

                    });
        }

        if ((extraParams != undefined) && (extraParams != null))
            queryString += "&" + jQuery.trim(extraParams);

         //alert(baseURL + queryString);
        window.open(baseURL + queryString);
    }

    
    /**
      *     Function for checking if at least a checkbox or a radio button of a group is selected
      *     @param name - name of the checkbox
      *     @return true if at least a checkbox/radio is checked else false  
      *     author Stelio Macumbe 02 of October 2008
     **/
    function anyChecked(name) {
        var size = jQuery(":checkbox[name='" + name + "']" 
                + " , " + ":radio[name='" + name + "']")
                .not(":disabled , [checked=false]").size();
        
        return !(size == 0);
    }

    function test() {
        alert("test 2");
    }
</script>
