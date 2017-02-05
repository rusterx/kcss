Dim computer 
computer = "."

Dim process  
process = "client_windows_amd64.exe"

Set service = GetObject("winmgmts:\\" & computer & "\root\cimv2")
Set results = service.ExecQuery(" Select * from Win32_Process where Name ='" & process & "'")

for each obj in results
      Set process_query = service.ExecQuery("Select * from Win32_Process Where ProcessID = '" & obj.ProcessID & "'")
      for each obj_process in process_query
      		obj_process.terminate()
      next
next