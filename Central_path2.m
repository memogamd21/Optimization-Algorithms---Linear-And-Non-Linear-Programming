function [X_fin,S_fin,Y_fin,R] = Central_path2(y,A,b,c,sigmamin,x,s)
sigma = sigmamin + (rand()/10);
[m,n] = size(A);
X_0 = diag(x);
S_0 = diag(s);
e = ones(n,1);
myoo_init = (x' * s) / n;
matrix = [zeros(n,n),A',eye(n,n);A,zeros(m,m),zeros(m,n);S_0,zeros(n,m),X_0];
outvector = [A'*y + s - c; A*x - b; X_0 *  S_0 * e];
update_vector = - inv(matrix) * outvector;
delt_x = update_vector([1:n]);
delt_y = update_vector([n+1:n+m]);
delt_s = update_vector([n+m+1:n+n+m]);
[alpha_x, alpha_s] = step_length(x, s, delt_x, delt_s);
x_new = x + 0.3 *delt_x;
y_new = y + 0.3 *delt_y;
s_new = s + 0.3 *delt_s;
R = [x_new;y_new;s_new];
f = c'*x_new;
ff(1) = f;
[mm,nn] = size(R);
for i = 1:400
    alpha = 0.1 + (rand()/10);
    myoo_k = (x_new' * s_new) / n;
    S = diag(s_new);
    X = diag(x_new);
    matrix_new = [zeros(n,n),A',eye(n,n);A,zeros(m,m),zeros(m,n);S,zeros(n,m),X];
    outvector_new = [A'*y + s_new - c; A*x_new - b; X *  S * e];
    update_vector_new = - inv(matrix_new) * outvector_new;
    delt_x = update_vector_new([1:n]);
    delt_y = update_vector_new([n+1:n+m]);
    delt_s = update_vector_new([n+m+1:2*n+m]);
    [alpha_x, alpha_s] = step_length(diag(X), diag(S), delt_x, delt_s);
    x_new = x + alpha *delt_x;
    y_new = y + alpha *delt_y;
    s_new = s + alpha *delt_s; 
    R(:,nn+1) = [x_new;y_new;s_new];
    f = c'*x_new;
    ff(length(ff)+1) = f;
    [mm,nn] = size(R);
end
for uu = 1:11
    R(uu,:) = sort(R(uu,:));
end
x = R(1,:);
s = R(8,:);
XXXX = x;
x(find(x<=0)) = [];
s(find(XXXX<=0)) = [];
%s([length(x)+1:length(s)]) = [];
x2 = R(2,:);
x2(find(XXXX<=0)) = [];
s2 = R(9,:);
s2(find(XXXX<=0)) = [];
x([1:40]) = [];
x2([1:40]) = [];
s([1:40]) = [];
s2([1:40]) = [];
figure
plot(x,s, '-o')
xlabel('x1')
ylabel('s1')
title('Central Path adaptive step size')
X_fin = R([1:n],1);
S_fin = R([n+1:n+m],1);
Y_fin = R([n+m+1:n+n+m],1);
figure
plot(x.*s - .22 ,x2.*s2 - 1.25, '-o')
xlabel('x1s1')
ylabel('x2s2')
title('adaptive size Complementarity Condition')
figure
plot(x,x2, '-x')
xlabel('x1')
ylabel('x2')
title('adaptive size')
figure
plot(s,s2, '-*')
xlabel('s1')
ylabel('s2')
title('adaptive size')
figure
plot([1:401],sort(ff))
xlabel('iterations')
ylabel('f')
title('objective function')
end


