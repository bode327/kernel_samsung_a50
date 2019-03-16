#!/sbin/sh

# backup_file <file>
backup_file() { [ ! -f $1~ ] && cp -fp $1 $1~; }

# restore_file <file>
restore_file() { [ -f $1~ ] && cp -fp $1~ $1; rm -f $1~; }

# replace_string <file> <if search string> <original string> <replacement string> <scope>
replace_string() {
  [ "$5" == "global" ] && local scope=g;
  if ! grep -q "$2" $1; then
    sed -i "s;${3};${4};${scope}" $1;
  fi;
}


# insert_line <file> <if search string> <before|after> <line match string> <inserted line>
insert_line() {
  local offset line;
  if ! grep -q "$2" $1; then
    case $3 in
      before) offset=0;;
      after) offset=1;;
    esac;
    line=$((`grep -n "$4" $1 | head -n1 | cut -d: -f1` + offset));
    if [ -f $1 -a "$line" ] && [ "$(wc -l $1 | cut -d\  -f1)" -lt "$line" ]; then
      echo "$5" >> $1;
    else
      sed -i "${line}s;^;${5}\n;" $1;
    fi;
  fi;
}

cp "/tmp/init.spectrum.rc" "/system_root/system/etc/init/hw/init.spectrum.rc"
cp "/tmp/init.spectrum.sh" "/system_root/system/etc/init/hw/init.spectrum.sh"
chmod 0644 /system_root/system/etc/init/hw/init.spectrum.rc
chmod 0755 /system_root/system/etc/init/hw/init.spectrum.sh
chmod 0644 /sys/fs/selinux/enforce
backup_file /system_root/system/etc/init/hw/init.rc
insert_line /system_root/system/etc/init/hw/init.rc "import /system/etc/init/hw/init.spectrum.rc" after "import /init.container.rc"  "import /system/etc/init/hw/init.spectrum.rc"
