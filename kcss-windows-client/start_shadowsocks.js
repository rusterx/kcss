String.prototype.format = function() {
    if (arguments.length == 0)
        return null;
    ret_str = this;
    for (var i = 0; i < arguments.length; i++) {
        var re = new RegExp('\\{' + i + '\\}', 'gm');
        ret_str = ret_str.replace(re, arguments[i]);
    }
    return ret_str;
};

var fso = new ActiveXObject('Scripting.FileSystemObject');
var shell = new ActiveXObject('WScript.Shell');

var script_full_name = WScript.ScriptFullName;
var script_folder = fso.GetParentFolderName(script_full_name)
var ss_exe_path = '"{0}\\shadowsocks-win-2.56\\Shadowsocks.exe"'.format(script_folder);

shell.run(ss_exe_path);