classdef fourierPath < handle
   properties
      coef {mustBeNumeric}; % size K      
      fr_K {mustBeNumeric};
      fr_N {mustBeNumeric};
      tm {mustBeNumeric}; % starts from 0
      circle_count = 0;
      
      vecs = [];
      
      rads = [];
      freqs = [];
      rads_sort = [];
      freqs_sort = [];
      
      origin = 0;
      max_range=[];
      tracks = [];
      original_data = [];
      animation = struct('cdata',[],'colormap',[]);
   end
   methods
      function obj = fourierPath(input_data, input_circle_count, input_start_frame, input_K)
         if nargin == 4
%             obj.fr_N = size(input_data,2);
            obj.fr_K = input_K;
            obj.original_data = input_data;
            
%             c = -2i*pi/obj.fr_K;
%             xn = repmat(val1, obj.fr_K, 1);
%             
%             [tmp1, tmp2] = meshgrid(0:obj.fr_N-1, 0:obj.fr_K-1);
%             tmp3 = tmp1.*tmp2;
%             en = exp(c.*tmp3);            
%             obj.coef = sum(xn.*en,2)/obj.fr_N;            
%             obj.coef = obj.coef';
            obj.coef = fft(input_data, obj.fr_K)/obj.fr_K;
            
            obj.rads = [real(obj.coef), 1i*imag(obj.coef)];            
            theta = 1i*2*pi/obj.fr_K;
            obj.freqs = [exp(theta).^(0:obj.fr_K-1), exp(theta).^(0:obj.fr_K-1)];
            
            [obj.rads_sort, sort_ind] = sort(obj.rads,'descend');
            obj.freqs_sort = obj.freqs(sort_ind);
            
            obj.tm = input_start_frame;
            obj.circle_count = input_circle_count;
            obj.update_state;
            
            margin = 1;
            obj.max_range = [min(real(input_data))-margin, max(real(input_data)+margin), min(imag(input_data)-margin), max(imag(input_data)+margin )];
            
         end
      end
      
      function next_time(obj)
          obj.tm = obj.tm+1;
          obj.update_state;
      end
            
      function update_state(obj)
          % Calculate vecs
          obj.vecs = obj.rads_sort(1:obj.circle_count).*(obj.freqs_sort(1:obj.circle_count).^obj.tm);
          
          obj.tracks = [obj.tracks obj.endPoint];
      end
      
      function y = endPoint(obj)          
          y = obj.origin + sum(obj.vecs(1:obj.circle_count));
      end
      
      function plot_class(obj)
          
          hold on;
%           tic;
          start_point = obj.origin; 
          tmp_points = zeros(1,obj.circle_count+1);
          
          tmp_points(1) = start_point;          
          for k = 1:obj.circle_count
              next_point = start_point + obj.vecs(k);
              tmp_points(k+1) = next_point;
              start_point = next_point;
          end 
          
%           tmp_A = triu(ones(obj.circle_count+1));
%           tmp_points = [obj.origin , obj.vecs]*tmp_A;
%           toc
         
          r = abs(obj.rads_sort(1:obj.circle_count)');
          c = [real(tmp_points(1:end-1))', imag(tmp_points(1:end-1))'];
          circles( r , c, 'color','c');
          
          plot( real(tmp_points), imag(tmp_points), 'r');
          
          plot(real(obj.tracks),imag(obj.tracks),'color','#0072BD'); 
          
      end
      
      function run_animation(obj, frames)
          obj.animation(frames) = struct('cdata',[],'colormap',[]);

          figure('units','normalized','outerposition',[0 0 1 1]);
          
          subplot(121);          
          plot(obj.original_data);
          title('Original Data');
          axis(obj.max_range);          
          pbaspect([1 1 1]);
          
          axis1 = subplot(122);
          title('Circle count : ' + string(obj.circle_count));
          axis(obj.max_range);          
          pbaspect([1 1 1]);
          tic;
          for j = 1:frames+1  
              cla(axis1);
              obj.next_time;
              obj.plot_class;

              drawnow;    
              obj.animation(j) = getframe;              
          end
          toc
      end
      
   end
end