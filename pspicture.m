classdef pspicture < handle
    
    properties
        columnwidth     = 252; %pt
        xscale          = 10; %pt
        yscale          = 10; %pt
        origin          = [0,1];
        psfigstr        = '';   % bevat alles dat in figuur moet
        height          = 14;   % baselineskip
        grid            = 'false';
    end
    
    methods
        function obj = pspicture()
        end
        
        function clrpsfigstr(obj)
            obj.psfigstr = '';
        end
        
        function addshape(obj,psfigstr)
            obj.psfigstr = strcat(obj.psfigstr,psfigstr);
        end
        
        function addtext(obj,x,y,pos,text)
            obj.psfigstr = strcat(obj.psfigstr,'\t\t\t\\rput[' ,pos, '](' ,num2str(x), ',' ,num2str(y), '){' ,text, '}\n' );
        end
        
        function addline(obj,x,y,style)
            basestr = strcat('\t\t\t\\psline[linestyle=',style,',linewidth=\\LineWidth]');
            obj.psfigstr = strcat(obj.psfigstr,basestr,pspicture.printpsdata(x,y),'\n');
        end
        
        function addaxis(obj,ox,oy,alx,aly)
            basestr = '\t\t\t\\psline[linestyle=solid,linewidth=\\LineWidth]';
            obj.psfigstr = strcat(obj.psfigstr,basestr,pspicture.printpsdata([ox,ox,ox+alx],[oy+aly,oy,oy]),'\n');
        end
        
        function adddots(obj,x,y,style)
            basestr = strcat('\t\t\t\\psdots[showpoints=true,dotstyle=',style,',dotscale=0.75]');
            obj.psfigstr = strcat(obj.psfigstr,basestr,pspicture.printpsdata(x,y),'\n');
        end
        
        function addxtick(obj,x,oy)
            basestr = '\t\t\t\\psline[linestyle=solid,linewidth=\\LineWidth]';
            obj.psfigstr = strcat(obj.psfigstr,basestr,pspicture.printpsdata([x x],[oy oy-0.2]),'\n');
        end
        
        function addytick(obj,ox,y)
            basestr = '\t\t\t\\psline[linestyle=solid,linewidth=\\LineWidth]';
            obj.psfigstr = strcat(obj.psfigstr,basestr,pspicture.printpsdata([ox ox+0.2],[y y]),'\n');
        end
        
        
        function makepsfigure(obj, psfigname)
            fid = fopen(psfigname,'w+');
            
            fprintf(fid,'\\documentclass[onecolumn,onesided]{el-author}\n\n');
            fprintf(fid,'\t\\usepackage{pstricks, pst-node, pst-plot, pst-circ}\n');
            fprintf(fid,'\t\\usepackage{moredefs}\n');
            fprintf(fid,'\t\\usepackage{geometry}\n\n');
            
            fprintf(fid,'\t\\newdimen\\xscale \\xscale=\\baselineskip\n');
            fprintf(fid,'\t\\newdimen\\yscale \\yscale=\\baselineskip\n\n');
            
            fprintf(fid,'\t\\setlength{\\hoffset}{-1in}\n');
            fprintf(fid,'\t\\setlength{\\oddsidemargin}{0pt}\n');
            fprintf(fid,'\t\\setlength{\\evensidemargin}{0pt}\n');
            fprintf(fid,'\t\\setlength{\\voffset}{-1in}\n');
            fprintf(fid,'\t\\setlength{\\topmargin}{0pt}\n');
            fprintf(fid,'\t\\setlength{\\headheight}{0pt}\n');
            fprintf(fid,'\t\\setlength{\\headsep}{0pt}\n');
            
            fprintf(fid,strcat('\t\\setlength{\\columnwidth}{',num2str(obj.columnwidth),'pt}\n'));
            fprintf(fid,'\t\\setlength{\\textwidth}{\\columnwidth}\n');
            fprintf(fid,'\t\\setlength{\\paperwidth}{\\columnwidth}\n');
            fprintf(fid,'\t\\setlength{\\pdfpagewidth}{\\columnwidth}\n');
            
            fprintf(fid,strcat('\t\\setlength{\\textheight}{',num2str(obj.height),'\\yscale}\n'));
            fprintf(fid,'\t\\setlength{\\paperheight}{\\textheight}\n');
            
            fprintf(fid,'\t\\providelength{\\LineWidth}\n');
            fprintf(fid,'\t\\setlength{\\LineWidth}{0.7pt}\n');
            
            fprintf(fid,'\t\\begin{document}\n');
            fprintf(fid,'\t\t\\pagestyle{empty}\n');
            fprintf(fid,'\t\t\\psset{unit=\\xscale}\n\n');
            fprintf(fid,strcat('\t\t\\noindent\\begin{pspicture}[showgrid=',obj.grid,'](0,0)(\\textwidth,\\textheight)\n'));
            
            % hier komt de eigenlijke psfigure
            
            fprintf(fid,obj.psfigstr);
            
            fprintf(fid,'\t\t\\end{pspicture}\n\n');
            fprintf(fid,'\t\\end{document}\n');
        end
    end
    
    methods (Static)
        function [ datastr ] = printpsdata( x,y )
            datastr = '';
            for index=1:max(length(x),length(y))
                datastr = strcat(datastr , '(' , num2str(x(index),'%6.6f') , ',', num2str(y(index),'%6.6f') ,')' );
            end
        end
        function [ xo ] = logscale( xi , ximin , ximax , xomin , xomax)
            xi  = log10(xi);    ximin = log10(ximin);   ximax = log10(ximax);
            a   = (xomax-xomin)/(ximax-ximin);          b = xomin-a*ximin;
            
            xo  = a*xi + b;
        end
    end
end

