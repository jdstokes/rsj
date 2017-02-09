
cnt = 0;
slImg = zeros(100,100,100);
startX = 50;
startY = 50;
startZ = 50;
for i = -slrad:slrad
    for j = -floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
        for k = -1:1%-floor(sqrt((slrad^2)-(i^2))):floor(sqrt((slrad^2)-(i^2)))
            if (i^2+j^2+k^2) <= (slrad^2)
%                 if (I(iter)+i) < size(megamask,1) && (J(iter)+j) < size(megamask,2) && (K(iter)+k) < size(megamask,3)
                    cnt = cnt +1;
                    slImg(startX + i,startY+j,startZ+k) = 1;
%                 end
            end
        end
    end
end