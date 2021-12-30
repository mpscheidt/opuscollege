package org.uci.opus.accommodation.service.expoint;

import org.uci.opus.accommodation.domain.StudentAccommodation;

/**
 * Use the RoomAllocationListener interface instead.
 * The accommodation module should not know anything about (accommodation) fees;
 * That's what the AccommodationFee module is for.
 * @author markus
 *
 */
@Deprecated
public interface RoomAllocationExtPoint {

    /**
     * 
     * @param studentAccommodation
     * @param writeWho
     * @return false when accommodation fee is not set (was not found) for the study taken by the student
     */
    @Deprecated
    boolean saveBalance(StudentAccommodation studentAccommodation, String writeWho);

}
