% 函数来检查射线是否击中收集器
function result = hits_collector(ray_origin, ray_direction, collector_radius, collector_base, collector_top)
    % Check if ray hits the cylindrical part of the collector
    % Using the equation of a line and a cylinder to check for intersection
    % a为距离
    a = ray_direction(1)^2 + ray_direction(2)^2;
    b = 2 * (ray_origin(1) * ray_direction(1) + ray_origin(2) * ray_direction(2));
    c = ray_origin(1)^2 + ray_origin(2)^2 - collector_radius^2;
    discriminant = b^2 - 4 * a * c;

    if discriminant >= 0
        t1 = (-b + sqrt(discriminant)) / (2 * a);
        t2 = (-b - sqrt(discriminant)) / (2 * a);
        z1 = ray_origin(3) + t1 * ray_direction(3);
        z2 = ray_origin(3) + t2 * ray_direction(3);

        % Check if the intersection points are on the cylindrical part of the collector
        if collector_base <= z1 && z1 <= collector_top || collector_base <= z2 && z2 <= collector_top
            result = true;
            return;
        end
    end

    % Check if ray hits the top cap of the collector
    % Using the equation of a line and a circle (in the xy-plane) to check for intersection
    t = (collector_top - ray_origin(3)) / ray_direction(3);
    x = ray_origin(1) + t * ray_direction(1);
    y = ray_origin(2) + t * ray_direction(2);
    if x^2 + y^2 <= collector_radius^2
        result = true;
        return;
    end

    result = false;
end






