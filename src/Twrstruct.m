function [Ixx_Twr,Iyy_Twr,Area_Twr,Mass_Twr,RGX_Twr,RGY_Twr] = Twrstruct(rhoTwr,ODTwr,IDTwr,TwrLength)
    % This function assumes the tower has the same OD and ID at the top as
    % it does at the bottom
    Area_Twr = pi/4*(ODTwr.^2 - IDTwr.^2);
    Ixx_Twr = pi/64*(ODTwr^4 - IDTwr^4);
    Iyy_Twr = Ixx_Twr;
    Mass_Twr = rhoTwr*TwrLength*Area_Twr;
    RGX_Twr = sqrt(Ixx_Twr/Area_Twr);
    RGY_Twr = RGX_Twr;

end