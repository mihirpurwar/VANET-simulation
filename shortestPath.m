function [dist,path] = shortestPath(nodes,segments,start_id,finish_id)

node_ids = nodes(:,1);
[num_map_pts,cols] = size(nodes);
table = sparse(num_map_pts,2);
shortest_distance = Inf(num_map_pts,1);
settled = zeros(num_map_pts,1);
path = num2cell(NaN(num_map_pts,1));
col = 2;
pidx = find(start_id == node_ids);
shortest_distance(pidx) = 0;
table(pidx,col) = 0;
settled(pidx) = 1;
path(pidx) = {start_id};
zz = find(finish_id == node_ids);

while (settled(zz) == 0)
    table(:,col-1) = table(:,col);
    table(pidx,col) = 0;
    
    neighbor_ids = [segments(node_ids(pidx) == segments(:,2),3);
        segments(node_ids(pidx) == segments(:,3),2)];
    
    for k = 1:length(neighbor_ids)
        cidx = find(neighbor_ids(k) == node_ids);
        if ~settled(cidx)
            d = sqrt(sum((nodes(pidx,2:cols) - nodes(cidx,2:cols)).^2));
            if (table(cidx,col-1) == 0) || ...
                    (table(cidx,col-1) > (table(pidx,col-1) + d))
                table(cidx,col) = table(pidx,col-1) + d;
                tmp_path = path(pidx);
                path(cidx) = {[tmp_path{1} neighbor_ids(k)]};
            else
                table(cidx,col) = table(cidx,col-1);
            end
        end
    end
    
    nidx = find(table(:,col));
    ndx = find(table(nidx,col) == min(table(nidx,col)));
    if isempty(ndx)
        break
    else
        pidx = nidx(ndx(1));
        shortest_distance(pidx) = table(pidx,col);
        settled(pidx) = 1;
    end
end

dist = shortest_distance(zz);
path = path(zz);
path = path{1};
end