folder_name = 'data/';
output_folder = 'out/';

%10,12,16,19,20
%2,4,7,8,12,13,14
inputImageN0 = 1;
inputImageN1 = 20;

% test each image
timeLimitSec = 120;

% start the timer
tStart = tic;

score = 0;

for i = inputImageN0:inputImageN1
    
    %load input image
    input_im_name = sprintf ( '%sOffice_Lens_Input_%d.jpg', ...
        folder_name, i );
    f = imread ( input_im_name );
    
    %load office lens output image
    output_im_name = sprintf('%sOffice_Lens_Output_%d.jpg',...
        folder_name, i );
    
    h = imread(output_im_name);
    
    %size of office lens output image
    Ro = size(h, 1);
    Co = size(h, 2);
    x = [Ro,Co];
    
% bestScale = 0;
% maxScore = 0;
% negOne = -1;
% justOne = 1;
% for x=1:10000
%     n1 = randi(5);
%     n2 = randi(5);
%     c1 = rand();
%     c2 = rand()+0.2;
%     fprintf('(%d,%d,%d,%d) ', n1, n2,c1,c2);
%     scale = vertcat(justOne(ones(n1,1),:).*c1,1, negOne(ones(n1,1),:).*c2);
%     disp(scale);
    
    % + repmat([-1 -1],1,randi(10));
    
    %run my_lens
    [g] = my_lens(f,x);
    
    output_test_im_name = sprintf('%sOffice_Lens_Output_%d_G.jpg',...
        output_folder, i );
    imwrite(g, output_test_im_name);
%     
%     output_test_im_name = sprintf('%sOffice_Lens_Output_%d_A.jpg',...
%         output_folder, i );
%     imwrite(a, output_test_im_name);
% 
%     if (b ~= 0)
%     output_test_im_name = sprintf('%sOffice_Lens_Output_%d_B.jpg',...
%     output_folder, i );
%     imwrite(b, output_test_im_name);
%     end
%     
%     if (c~=0)
%     output_test_im_name = sprintf('%sOffice_Lens_Output_%d_C.jpg',...
%     output_folder, i );
%     imwrite(c, output_test_im_name);
%     end
    
    %score
    try
        currentScore = 255 - mean ( abs ( int16(g(:)) - int16(h(:)) ) );    

        score = score + currentScore;

%         if (score > maxScore)
%            fprintf('\nprevScore:%d   NewBest:%d\n', maxScore, score);
%            maxScore = score;
%            bestScale = scale;
% %            disp(scale);
%             disp(n1);
%             disp(n2);
%             disp(c1);
%             disp(c2);
%             disp(scale);
%         end
    catch
    end
    

    
    %check time
    elapsedTime = toc(tStart);
    if ( elapsedTime  >= timeLimitSec )
        return;
    else
        fprintf( '%d - score [%.2f] - time [%.3f sec] -> total score [%.2f]\n',...
                i, currentScore, elapsedTime, score);
    end 

end
fprintf ( 'final - score [%.2f] - time [%.3f sec]\n', score, elapsedTime  );
