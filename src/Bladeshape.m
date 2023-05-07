function [Chord,Twist,Circ,Height,Radius,TAxis] = Bladeshape(segLength1,segLength2,bladeNodes,H,AR,ChordLength,bladeOffset)
    S = 0.5; 
    z = linspace(0,2*H,bladeNodes)';
    R_true = H/AR;
    z1 = linspace(-H,H,bladeNodes)';
    
    N2 = 7000;
    aa = linspace(0.01,5,N2);
    R_approx = -aa + aa.*cosh(H./aa);
    R = interp1(R_approx,R_approx,R_true,'nearest');
    for j = 1:N2
        if (R_approx(j) == R)
            a = aa(j);
        end
    end
    % The equation below is for visualization purposes
    % The equation we will export must be shifted and flipped due to the way
    % that Qblade takes in data
    y_viz = a*cosh(z1/a) - a*cosh(H/a);
    y_calc = -a*cosh(z/a - H/a) + a*cosh(H/a); % use this for calculations in Qblade
    figure
    plot(z1,y_viz,'b','LineWidth',1.5)
    hold on
    plot([-H H],[0 0],'k','LineWidth',1.5)
    hold off
    title('Catenary Blade Shape Plot (For Visualization Purposes)')
    grid on
    axis equal
    axis([-(H+1) (H+1) -inf 1])
    %maximum value occurs -a + a cosh(H/a)
    Twist = num2str(zeros(bladeNodes,1));
    Circ = num2str(zeros(bladeNodes,1));
    Height = num2str(0.3048*z);
    Radius = num2str(0.3048*(y_calc+bladeOffset));
    TAxis = num2str(S*ones(bladeNodes,1));
    
    Chord = ones(bladeNodes,1);
    % For reference: first set of testing numbers were 1:5, 6:29, 30:34
    Chord(1:segLength1) = ChordLength*Chord(1:segLength1);
    Chord(segLength1+1:segLength1+segLength2) = ChordLength*Chord(segLength1+1:segLength1+segLength2);
    Chord(segLength1+segLength2+1:end) = ChordLength*Chord(segLength1+segLength2+1:end);
    Chord = num2str(Chord);
end