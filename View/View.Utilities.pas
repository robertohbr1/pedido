unit View.Utilities;

interface

uses Winapi.Windows;

procedure SendKeysTab;

implementation

procedure SendKeysTab;
begin
  keybd_event(VK_TAB, 0, 0, 0);
  keybd_event(VK_TAB, 0, KEYEVENTF_KEYUP, 0);
end;

end.
