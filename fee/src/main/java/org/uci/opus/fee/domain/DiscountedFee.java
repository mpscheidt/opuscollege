package org.uci.opus.fee.domain;

public class DiscountedFee {

    private Fee fee;
    private double discountedFeeDue;

    /**
     * If the discountPercentage is > 100, it will used as 100.
     * @param fee
     * @param discountPercentage
     */
    public DiscountedFee(Fee fee, double discountPercentage) {
        setFee(fee);

        discountPercentage = discountPercentage > 100 ? 100 : discountPercentage;
        setDiscountedFeeDue(fee.getFeeDue().doubleValue() * (100 - discountPercentage) / 100);
    }

    public double getDiscountedFeeDue() {
        return discountedFeeDue;
    }

    public void setDiscountedFeeDue(double discountedFeeDue) {
        this.discountedFeeDue = discountedFeeDue;
    }

    public Fee getFee() {
        return fee;
    }

    public void setFee(Fee fee) {
        this.fee = fee;
    }
    

}
