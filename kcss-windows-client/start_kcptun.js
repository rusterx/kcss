function trim(str){
	return str.replace(/(^\s*)|(\s*$)/g,"");
}


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

var file = fso.OpenTextFile('shadowsocks-win-2.56/gui-config.json',1, true);
var text = file.ReadAll();
var ssservers = '';

eval('ssservers=' + text + ';');

var ss_index = ssservers.index;
var ss_config = ssservers.configs;
var ss_current_remark = ss_config[ss_index].remarks;
var ss_current_server = trim(ss_current_remark.split(':')[0]);

var script_full_name = WScript.ScriptFullName;
var script_folder = fso.GetParentFolderName(script_full_name)

// start kcptun
var kcptun_exe_path = '"{0}\\kcptun\\client_windows_amd64.exe" -c "{0}\\kcptun\\{1}.json"'.format(script_folder, ss_current_server.toUpperCase());
shell.run(kcptun_exe_path, 0, false);