clear all
close all
clc
%% Problem Definition

% Define the details of the table design problem
nVar = 5;           % Number of Decision Variables
ub = [5.5 5.8 0.8 8 0.1];      % Upper Bound of Variables
lb = [4.5 4.5 0.5 6 0.07];     % Lower Bound of Variables
fobj = @ObjectiveFunction;      % Cost Function 

%% PSO Parameters

% Define the PSO's paramters 
noP = 15;           % Population Size (Swarm Size)
maxIter = 2;        % Maximum Number of Iterations
wMax = 0.9;         % Inertia
wMin = 0.2;         % Inertia
c1 = 2;             % Personal Learning Coefficient
c2 = 2;             % Global Learning Coefficient

% Velocity Limits
vMax = (ub - lb) .* 0.2; 
vMin  = -vMax;
 

%% Initialization

for k = 1 : noP
    Swarm.Particles(k).X = (ub-lb) .* rand(1,nVar) + lb; 
    Swarm.Particles(k).V = zeros(1, nVar); 
    Swarm.Particles(k).PBEST.X = zeros(1,nVar); 
    Swarm.Particles(k).PBEST.O = inf; 
    
    Swarm.GBEST.X = zeros(1,nVar);
    Swarm.GBEST.O = inf;
end


%% Main loop
for t = 1 : maxIter
    
    % Calcualte the objective value
    for k = 1 : noP
        currentX = Swarm.Particles(k).X;
        Swarm.Particles(k).O = fobj(currentX);
        
        % Update the PBEST
        if Swarm.Particles(k).O < Swarm.Particles(k).PBEST.O 
            Swarm.Particles(k).PBEST.X = currentX;
            Swarm.Particles(k).PBEST.O = Swarm.Particles(k).O;
        end
        
        % Update the GBEST
        if Swarm.Particles(k).O < Swarm.GBEST.O
            Swarm.GBEST.X = currentX;
            Swarm.GBEST.O = Swarm.Particles(k).O;
        end
    end
    
    % Update the X and V vectors 
    w = wMax - t .* ((wMax - wMin) / maxIter);
    
    for k = 1 : noP
        Swarm.Particles(k).V = w .* Swarm.Particles(k).V + c1 .* rand(1,nVar) .* (Swarm.Particles(k).PBEST.X - Swarm.Particles(k).X) ...
                                                                                     + c2 .* rand(1,nVar) .* (Swarm.GBEST.X - Swarm.Particles(k).X);
                                                                                 
        
        % Check velocities 
        index1 = find(Swarm.Particles(k).V > vMax);
        index2 = find(Swarm.Particles(k).V < vMin);
        
        Swarm.Particles(k).V(index1) = vMax(index1);
        Swarm.Particles(k).V(index2) = vMin(index2);
        
        Swarm.Particles(k).X = Swarm.Particles(k).X + Swarm.Particles(k).V;
        
        % Check positions 
        index1 = find(Swarm.Particles(k).X > ub);
        index2 = find(Swarm.Particles(k).X < lb);
        
        Swarm.Particles(k).X(index1) = ub(index1);
        Swarm.Particles(k).X(index2) = lb(index2);
        
    end
    
    outmsg = ['Iteration# ', num2str(t) , ' Swarm.GBEST.O = ' , num2str(Swarm.GBEST.O)];
    disp(outmsg);
    
    cgCurve(t) = Swarm.GBEST.O;
end
 
semilogy(cgCurve);
xlabel('Iteration#')
ylabel('Weight')