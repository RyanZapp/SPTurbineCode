function [AreaCable,IyyCable] = Cablestruct(CableDiam)
    AreaCable = pi/4*CableDiam.^2;
    IyyCable = pi/64*CableDiam.^4;

end