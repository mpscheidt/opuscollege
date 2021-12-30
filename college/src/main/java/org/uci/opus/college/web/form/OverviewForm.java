package org.uci.opus.college.web.form;

import java.util.List;

public class OverviewForm<T> extends Form<T> {

    private List<T> allItems;

    public OverviewForm() {
        super();
    }

    public List<T> getAllItems() {
        return allItems;
    }

    public void setAllItems(List<T> allItems) {
        this.allItems = allItems;
    }

}
