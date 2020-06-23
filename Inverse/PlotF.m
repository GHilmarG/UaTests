function Fig=PlotF(CtrlVar,MUA,F,TypeOfPlot,varargin)

switch TypeOfPlot
    
    case 'sbB'
        
        if numel(varargin) == 0
            
            varargin{1}='Blue';
            varargin{2}='Green';
            varargin{3}='Maroon';
            palette='HTML4';
            [Name,RGB]=colornames(palette,varargin{1});  sCol=RGB;
            [Name,RGB]=colornames(palette,varargin{2});  bCol=RGB;
            [Name,RGB]=colornames(palette,varargin{3});  BCol=RGB;
        else
            
            if ischar(varargin{1})
                palette='MATLAB';
                [Name,RGB]=colornames(palette,varargin{1});  sCol=RGB;
                [Name,RGB]=colornames(palette,varargin{2});  bCol=RGB;
                [Name,RGB]=colornames(palette,varargin{3});  BCol=RGB;
            end
            
        end
        
        Fig=figure ;
        Plot_sbB(CtrlVar,MUA,F.s,F.b,F.B,[],[],[],[],[],sCol,bCol,BCol) ;
        
    otherwise
        
        fprintf(' Not implemented.\n')
end




end