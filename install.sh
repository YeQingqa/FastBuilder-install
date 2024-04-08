echo -e "
 ${plain}(${red}1${plain}) ${lan}安装 Neomega
 ${plain}(${red}2${plain}) ${lan}安装 FastBuilder
 ${plain}(${red}3${plain}) ${lan}安装 FastBuilder-Libre${plain}"
echo && read -p "请输入数字: " num

case "${num}" in
    0) exit 0
    ;;
    1) bash -c "$(curl -fsSL https://omega-1259160345.cos.ap-nanjing.myqcloud.com/fastbuilder_launcher/install.sh)"
    ;;
    2) export PB_USE_GH_REPO=1  && bash -c "$(curl -fsSL https://download.yeqingg.cn/fastbuilder/install.sh)"
    ;;
    3) export PB_USE_GH_REPO=1  && bash -c "$(curl -fsSL https://download.yeqingg.cn/fastbuilderlibre/install.sh)"
    ;;
    *) echo -e "${red}请输入数字[0-3]${plain}"
    ;;
esac
