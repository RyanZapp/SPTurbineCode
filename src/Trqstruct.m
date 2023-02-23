function [Ixx_Trq,Iyy_Trq,Area_Trq,Mass_Trq,RGX_Trq,RGY_Trq] = Trqstruct(rhoTrq,ODTrq,IDTrq,TrqLength)
    % This function assumes the torquetube has the same OD and ID at the top as
    % it does at the bottom
    Area_Trq = pi/4*(ODTrq.^2 - IDTrq.^2);
    Ixx_Trq = pi/64*(ODTrq^4 - IDTrq^4);
    Iyy_Trq = Ixx_Trq;
    Mass_Trq = rhoTrq*TrqLength*Area_Trq;
    RGX_Trq = sqrt(Ixx_Trq/Area_Trq);
    RGY_Trq = RGX_Trq;
end