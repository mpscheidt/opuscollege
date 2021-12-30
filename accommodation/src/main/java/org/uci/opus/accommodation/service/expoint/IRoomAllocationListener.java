package org.uci.opus.accommodation.service.expoint;

import javax.servlet.http.HttpServletRequest;

import org.uci.opus.accommodation.domain.StudentAccommodation;

public interface IRoomAllocationListener {

    void roomAllocated(StudentAccommodation studentAccommodation, HttpServletRequest request);

    void roomDeallocated(StudentAccommodation studentAccommodation, HttpServletRequest request);

}
