#!/bin/sh

template_file="/etc/samba/smb.template.conf"

# Edit samba config
if [ -n "$WORKGROUP" ]; then
    sed -i "s/workgroup = HOME/workgroup = $WORKGROUP/" $template_file
fi

if [ -n "$MACHINENAME" ]; then
    sed -i "s/netbios name = FILES/netbios name = $MACHINENAME/" $template_file
fi

if [ -n "$MACHINETITLE" ]; then
    sed -i "s/server string = File Server/server string = $MACHINETITLE/" $template_file
fi

# Create Samba users
for i in $(seq 1 100); do
    eval user_var="USER${i}_NAME"
    eval uid_var="USER${i}_UID"
    #eval gid_var="USER${i}_GID"
    eval pass_var="USER${i}_PASSWORD"

    eval pass_file_var="USER${i}_PASSWORD_FILE"

    eval user_name="\${$user_var}"
    eval user_uid="\${$uid_var}"
    #eval user_gid="\${$gid_var}"
    eval user_pass="\${$pass_var}"
    eval user_pass_file="\${$pass_file_var}"

    if [ -z "$user_pass" ] && [ -n "$user_pass_file" ]; then
        user_pass=$(cat "$user_pass_file")
    fi

    if [ -z "$user_name" ]; then
        break
    fi

    # Create user if not exists
    if ! id "$user_name" >/dev/null 2>&1; then
        if [ -z "$user_uid" ]; then
            adduser -D -G users -s /sbin/nologin "$user_name"
        else
            adduser -D -G users -u "$user_uid" -s /sbin/nologin "$user_name"
        fi
    fi

    # Set password for Samba
    (echo "$user_pass"; echo "$user_pass") | smbpasswd -a -s "$user_name"
done

# Configure shared directories
for i in $(seq 1 100); do
    eval share_var="SHARE${i}_NAME"
    eval path_var="SHARE${i}_PATH"
    eval comment_var="SHARE${i}_COMMENT"
    eval browseable_var="SHARE${i}_BROWSEABLE"
    eval write_list_var="SHARE${i}_WRITE_LIST"
    eval read_only_var="SHARE${i}_READ_ONLY"

    eval share_name="\${$share_var}"
    eval share_path="\${$path_var}"
    eval share_comment="\${$comment_var}"
    eval share_browseable="\${$browseable_var}"
    eval share_write_list="\${$write_list_var}"
    eval share_read_only="\${$read_only_var}"

    if [ -z "$share_name" ] || [ -z "$share_path" ]; then
        break
    fi

    # Set defaults
    [ -z "$share_comment" ] && share_comment="$share_name"
    [ -z "$share_browseable" ] && share_browseable="yes"
    [ -z "$share_read_only" ] && share_read_only="yes"
    [ -z "$share_write_list" ] && share_write_list="@users"

    # Build share config
    {
        echo "[$share_name]"
        echo "comment = $share_comment"
        echo "path = $share_path"
        echo "write list = $share_write_list"
        echo "read only = $share_read_only"
        echo "browseable = $share_browseable"
        echo "oplocks = False"
        echo "level2 oplocks = False"
        echo
    } >> "$template_file"

    echo "Configured share $share_name at $share_path"
done

cp $template_file /etc/samba/smb.conf
smbd --foreground
