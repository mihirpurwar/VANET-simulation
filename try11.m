nodes = [(1:6);2,5,4,6,3,7;1,4,1,7,3,2]';
segments = [(1:7);1,1,2,2,2,2,3;3,5,3,4,5,6,5]'
start_id=3;
finish_id=6;

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
neighbor_ids = [segments(node_ids(pidx) == segments(:,2),3);
            segments(node_ids(pidx) == segments(:,3),2)]
length(neighbor_ids)