package org.uci.opus.accommodation.validator;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;
import org.uci.opus.accommodation.domain.Room;
import org.uci.opus.accommodation.service.HostelManagerInterface;

@Component
public class RoomValidator implements Validator {

	@Autowired private HostelManagerInterface hostelManager;
	 
	Logger log = LoggerFactory.getLogger(RoomValidator.class);

    @Override
    public boolean supports(Class<?> clazz) {
        return Room.class.isAssignableFrom(clazz);
    }

    @Override
    public void validate(Object obj, Errors errors) {

    	Room room = (Room)obj;
    	
    	int roomId = room.getId();
    	
        ValidationUtils.rejectIfEmpty(errors, "code", "invalid.empty.format");
        ValidationUtils.rejectIfEmpty(errors, "roomTypeCode", "invalid.empty.format");
        
        if (0 == (Integer) errors.getFieldValue("hostel.id")) {
            errors.rejectValue("hostel.id", "invalid.empty.format");
        }

        if (0 == (Integer) errors.getFieldValue("numberOfBedSpaces")) {
            errors.rejectValue("numberOfBedSpaces", "invalid.empty.format");
        }

        if ("0".equals(errors.getFieldValue("roomTypeCode"))) {
            errors.rejectValue("roomTypeCode", "invalid.empty.format");
        }
        
        Map<String,Object> params = new HashMap<String, Object>();
        params.put("code", room.getCode());
        
        //look for rooms with same code
        if (hostelManager.isRoomRepeated(roomId, params))        	
            errors.rejectValue("code", "jsp.accommodation.error.roomCodeExist");


        
    }

}
