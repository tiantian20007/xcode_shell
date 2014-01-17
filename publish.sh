XCODE_SHELL="/Users/leshu-2/Documents/repository/xcode_shell"
SHARE_ROOT="/Users/leshu-2/Documents/repository/leshu/sjsg/shared"
PUBLISH_IOS="/Users/leshu-2/Documents/repository/leshu/sjsg/published/IOS"

JSTOJSC_PATH="/Users/leshu-2/Documents/repository/leshu/sjsg/libs/cocos2d-x/tools/cocos2d-console/console"
publish_js="/Users/leshu-2/Documents/repository/leshu/sjsg/published/IOS/javascript/"
lib_js="/Users/leshu-2/Documents/repository/leshu/sjsg/libs/cocos2d-x/scripting/javascript/bindings/js/"

cd ${XCODE_SHELL}/

# get publish date
DATE=$(date +%Y%m%d%H%M)
echo $DATE

cat << EOF >version.json
{
    "version":$DATE,
	"resource":$DATE
}
EOF

# git reset remove pull
echo start pull resources and codes......................
cd ../leshu/sjsg/
git clean -d -f
git reset --hard HEAD
git pull
git submodule init
git submodule update
cd libs/cocos2d-x/
git submodule init
git submodule update

# excel to json
echo start convert excel to json.....................
cd ${SHARE_ROOT}/
python excel2json.py batch
cd ${XCODE_SHELL}/

# copy json to publish directory
echo start copy json file ...........................
if [ -d "$PUBLISH_IOS"/data ]; then
    rm -rf "$PUBLISH_IOS"/data
fi
if [ -d "$PUBLISH_IOS"/data/ioris ]; then
    rm -rf "$PUBLISH_IOS"/data/ioris
fi
if [ -d "$PUBLISH_IOS"/data/mais ]; then
    rm -rf "$PUBLISH_IOS"/data/mais
fi
if [ -d "$PUBLISH_IOS"/data/monster ]; then
    rm -rf "$PUBLISH_IOS"/data/monster
fi

mkdir "$PUBLISH_IOS"/data
mkdir "$PUBLISH_IOS"/data/ioris
mkdir "$PUBLISH_IOS"/data/mais
mkdir "$PUBLISH_IOS"/data/monster

for file in "$SHARE_ROOT"/res/data/*.unity3d
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/data
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/data
    fi
done
for file in "$SHARE_ROOT"/res/data/ioris/*.unity3d
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/data/ioris
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/data/ioris
    fi
done
for file in "$SHARE_ROOT"/res/data/mais/*.unity3d
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/data/mais
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/data/mais
    fi
done
for file in "$SHARE_ROOT"/res/data/monster/*.unity3d
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/data/monster
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/data/monster
    fi
done


# copy configlist file to publish dir
for file in "$SHARE_ROOT"/res/config.plist
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/config.plist
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/config.plist
    fi
done

for file in "$XCODE_SHELL"/version.json
    do
    if [ -d "$file" ]; then
        cp -rf "$file" "$PUBLISH_IOS"/version.json
    fi
    
    if [ -f "$file" ]; then
        cp "$file" "$PUBLISH_IOS"/version.json
    fi
done

# js to jsc
python "$JSTOJSC_PATH"/cocos2d.py jscompile -s $publish_js -d $publish_js;
echo clean js file in publish folders
find $publish_js -type f -name "*.js" | xargs rm -rf;

python "$JSTOJSC_PATH"/cocos2d.py jscompile -s $lib_js -d $lib_js;
echo clean js file in lib folders
find $lib_js -type f -name "*.js" | xargs rm -rf;

#start publish ipa to php 
echo start publish ipa...................................
./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c Debug -o ~/Desktop/ -t MyGame  -p 拳皇世界 -n
./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios

#./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c share -o ~/#Desktop/ -t AnimationPro91  -p 烽火战神91
#./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios

#./ipa-build /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios -c share -o ~/#Desktop/ -t DramaPlayer  -p 剧本播放器
#./ipa-publish /Users/leshu-2/Documents/repository/leshu/sjsg/proj.ios
