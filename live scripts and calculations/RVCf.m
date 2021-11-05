clc
clear
startup_rvc

alpha = [pi/2 ,pi/2 ,0 ,0 ,pi/4 ,-pi/4 ];
a = [0 ,0 ,0 ,450 ,0 ,0 ];

l(1) = Link('prismatic', 'theta', 0, 'a', 0, 'alpha', pi/2,'modified');
l(2) = Link('revolute', 'd', 0, 'a', 0, 'alpha', pi/2,'modified');
l(3) = Link('prismatic', 'theta', pi/2, 'a', a(3), 'alpha', 0,'offset',465+50+2*285,'modified');
l(4) = Link('revolute', 'd', 0, 'a', a(4), 'alpha', alpha(4),'modified');
l(5) = Link('revolute', 'd', 0, 'a', a(5), 'alpha', alpha(5),'modified');
l(6) = Link([0,0,0,-pi/4],'modified');
R = SerialLink(l,'name', 'Derafsh e Kaviany');

% ---- Traj1 ----
% samples = 500;
% 
% time = linspace(0,10, samples);
% x = 400*sin(5*time);
% y = 400*cos(5*time) - 1500;
% z = 400*sin(6*time) - 1800;


% ---- Traj2 ----
samples = 500;

time = linspace(0,12, samples);
x = 350*sin(10*pi/3*time);
y = -100*time - 400;
z = -(x.^2/150 - (y+1000).^2/200)/4 - 2000;

T = [x' y' z'];

q = zeros(samples,6);
for index = 1:samples
   Px = T(index,1);
   Py = T(index,2);
   Pz = T(index,3);
   [q1,q2,q3,q4,q5,q6] = inverse_kine(Px,Py,Pz);
   q(index,:) = [q1,q2,q3,q4,q5,q6];
end

figure(1)

subplot(3,6,[1,2])
should_be_plotted = reshape(T(:,1), 1,samples);
plot(should_be_plotted,'r');
ylim([min(should_be_plotted)-10,max(should_be_plotted)+10]);
title("X");

subplot(3,6,[3,4])
should_be_plotted = reshape(T(:,2), 1,samples);
plot(should_be_plotted,'r');
ylim([min(should_be_plotted)-50,max(should_be_plotted)+50]);
title("Y");

subplot(3,6,[5,6])
should_be_plotted = reshape(T(:,3), 1,samples);
plot(should_be_plotted,'r');
ylim([min(should_be_plotted)-100,max(should_be_plotted)+100]);
title("Z");

subplot(3,6,[7,8])
plot(q(:,1));
title("d_1");

subplot(3,6,[9,10])
plot(q(:,2));
title("\theta_2");

subplot(3,6,[11,12])
plot(q(:,3));
title("d_3");

subplot(3,6,[13,15])
plot(q(:,4));
title("\theta_4");

subplot(3,6,[16,18])
plot(q(:,5));
title("\theta_5");

figure(2)
clf

subplot(1,2,2);
plot3(T(:,1),T(:,2),T(:,3),'-*r');
grid on
title("Trajectory");


subplot(1,2,1);
title("3D animation")
R.plot(q,'workspace', [-2000 2000 -3000 200 -4000 0]);

function [q1,q2,q3,q4,q5,q6] = inverse_kine(X,Y,Z)
    q2 = -asin(X/450);
    q1 = -Y - 450*cos(q2);
    q3 = - 465 - 50 - 2*285 - Z;
    q4 = -q2;
    q5 = 0;
    q6 = 0;
end