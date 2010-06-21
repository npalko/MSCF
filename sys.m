classdef sys < handle
  methods (Static)
    function setstatusvisability(isvisible)
      desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
      desktop.getMainFrame.getStatusBar.getParent.setVisible(isvisible);
    end
  end
end