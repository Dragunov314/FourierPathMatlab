function result = read_SVG_polyline(filename)

    code = fileread(filename);
    tree = htmlTree(code);
    selector = "polyline";
    subtrees = findElement(tree,selector);
    attr = "points";
    points_str = getAttribute(subtrees,attr);
    data = sscanf(points_str,'%f,%f');
    x = data(1:2:end)';
    y = data(2:2:end)';
    result = conj(x+1i*y);
    result = normalize(result);%-mean(result);
end