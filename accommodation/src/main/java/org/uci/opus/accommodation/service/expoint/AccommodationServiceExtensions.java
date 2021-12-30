package org.uci.opus.accommodation.service.expoint;

import java.lang.reflect.Field;
import java.util.Collection;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.uci.opus.accommodation.domain.StudentAccommodation;
import org.uci.opus.college.service.extpoint.ExtensionPointUtil;
import org.uci.opus.college.web.extpoint.IExtensionCollection;

@Service
public class AccommodationServiceExtensions implements IExtensionCollection {

    private static Logger log = LoggerFactory.getLogger(AccommodationServiceExtensions.class);

    @Autowired private ExtensionPointUtil extensionPointUtil;

    private Collection<RoomAllocationExtPoint> roomAllocationExtensions;

    // listeners
    private Collection<IRoomAllocationListener> roomAllocationListeners;

    public Collection<RoomAllocationExtPoint> getRoomAllocationExtensions() {
        return roomAllocationExtensions;
    }

    @Autowired(required=false)
    public void setRoomAllocationExtensions(Collection<RoomAllocationExtPoint> roomAllocationExtensions) {
        this.roomAllocationExtensions = roomAllocationExtensions;
        extensionPointUtil.logExtensions(log, RoomAllocationExtPoint.class, roomAllocationExtensions);
    }
    
    /**
     * Delegate method.
     * @param studentAccommodation
     * @param writeWho
     */
    @Deprecated
    public boolean saveBalance(StudentAccommodation studentAccommodation, String writeWho) {
        boolean result = true;
        if (roomAllocationExtensions != null) {
            for (RoomAllocationExtPoint extension : roomAllocationExtensions) {
                result &= extension.saveBalance(studentAccommodation, writeWho);
            }
        }
        return result;
    }

    public Collection<IRoomAllocationListener> getRoomAllocationListeners() {
        return roomAllocationListeners;
    }

    @Autowired(required=false)
    public void setRoomAllocationListeners(Collection<IRoomAllocationListener> listeners) {
        this.roomAllocationListeners = listeners;
        extensionPointUtil.logExtensions(log, IRoomAllocationListener.class, listeners);
    }

    public void roomAllocated(final StudentAccommodation studentAccommodation, HttpServletRequest request) {
        if (roomAllocationListeners != null) {
            for (IRoomAllocationListener extension : roomAllocationListeners) {
                extension.roomAllocated(studentAccommodation, request);
            }
        }
    }

    public void roomDeallocated(final StudentAccommodation studentAccommodation, HttpServletRequest request) {
        if (roomAllocationListeners != null) {
            for (IRoomAllocationListener extension : roomAllocationListeners) {
                extension.roomDeallocated(studentAccommodation, request);
            }
        }
    }

    @Override
    public Field[] getExtensions() {
        return this.getClass().getDeclaredFields();
    }

}
