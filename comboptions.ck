public class CombOptions {
    0.125 => float shiftMin;
    0.5 => float shiftMax;
    
    0.25 => float rateMin;
    0.75 => float rateMax;
    
    0.0 => float pan;
    
    1.0 => float rmix;
    
    60-12 => float tune1;
    64-12 => float tune2;
    72-12 => float tune3;
    79-12 => float tune4;
 
    fun CombOptions clone() {
        CombOptions clone;
        
        shiftMin => clone.shiftMin;
        shiftMax => clone.shiftMax;
        
        rateMin => clone.rateMin;
        rateMax => clone.rateMax;
        
        pan => clone.pan;
        
        rmix => clone.rmix;
        
        tune1 => clone.tune1;
        tune2 => clone.tune2;
        tune3 => clone.tune3;
        tune4 => clone.tune4;
        
        return clone;
    }   
}


