% The COBRAToolbox: testFBA.m
%
% Purpose:
%     - tests the basic functionality of FBA
%       Tests four basic solution: Optimal minimum 1-norm solution, Optimal
%       solution on fructose, Optimal anaerobic solution, Optimal ethanol
%       secretion rate solution returns 1 if all tests were completed succesfully, 0 if not
%
% Authors:
%     - Original file: Joseph Kang 04/27/09
%     - CI integration: Laurent Heirendt January 2017
%
% Note:
%     - The solver libraries must be included separately

% define the path to The COBRAToolbox
pth = which('initCobraToolbox.m');
CBTDIR = pth(1:end-(length('initCobraToolbox.m') + 1));

cd([CBTDIR '/test/verifiedTests/testFBA'])

% set the tolerance
tol = 1e-8;

% load the model
load('testFBAData.mat');

% set the solver
changeCobraSolver('tomlab_cplex')

%% check the optimal solution - BiomassEcoli
fprintf('\n>> Optimal minimum 1-norm solution\n');
model = changeObjective(model, {'BiomassEcoli'}, 1);
solution = optimizeCbModel(model);
f_values = solution.f;

%testing if f values are within range
for i = 1:size(f_values)
    assert(abs(solution.f - solutionStd.f) < tol)
end

%testing if c*x == f
for i = 1:size(f_values)
    assert(abs(model.c'*solution.x - solution.f) < tol)
end

% print the flux vector
printFluxVector(model, solution.x, true, true);

%% check the optimal solution - fructose
fprintf('\n>> Optimal solution on fructose\n');
model2 = changeRxnBounds(model, {'EX_glc(e)','EX_fru(e)'}, [0 -9], 'l');
solution2 = optimizeCbModel(model2);
f_values = solution.f;

%testing if f values are within range
for i = 1:size(f_values)
    assert(abs(solution2.f - solution2Std.f) < tol)
end

%testing if c*x == f
for i = 1:size(f_values)
    assert(abs(model2.c'*solution2.x - solution2.f) < tol)
end

% print the flux vector
printFluxVector(model2, solution.x, true, true);

%% check the optimal anaerobic solution
fprintf('\n>> Optimal anaerobic solution\n');
model3 = changeRxnBounds(model, 'EX_o2(e)', 0, 'l');
solution3 = optimizeCbModel(model3);
f_values = solution.f;

%testing if f values are within range
for i = 1:size(f_values)
    assert(abs(solution3.f - solution3Std.f) < tol)
end

%testing if c*x == f
for i = 1:size(f_values)
    assert(abs(model3.c'*solution3.x - solution3.f) < tol)
end

%% check the optimal ethanol secretion rate solution
fprintf('\n>> Optimal ethanol secretion rate solution \n');
model4 = changeObjective(model, 'EX_etoh(e)', 1);
solution4 = optimizeCbModel(model4);
f_values = solution.f;

%testing if f values are within range
for i = 1:size(f_values)
    assert(abs(solution4.f - solution4Std.f) < tol)
end

%testing if c*x == f
for i = 1:size(f_values)
    assert(abs(model4.c'*solution4.x - solution4.f) < tol)
end

% change the directory
cd(CBTDIR)
