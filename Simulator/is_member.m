function [id] = is_member(pars,assigned_pars)
i_len = length(assigned_pars);
j_len = length(pars);
id = zeros(length(assigned_pars),1);
for ii = 1:1:i_len
    for jj = 1:1:j_len
        if assigned_pars(ii,:) == pars(jj,:)
            id(ii) = jj;
        end
    end
end
end