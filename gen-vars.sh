source vars.env
cat vars.templ | gomplate > vars.tf
cat userdata.templ | gomplate > userdata.sh
