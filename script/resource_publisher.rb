# =======================================================
# Resourceファイルアップロード準備作業スクリプト
# =======================================================
require "json"
require 'fileutils'

# -------------------------------------------------------
# 定義情報
# -------------------------------------------------------
def srcDir = "./fsh-generated/resources/"
def destDir = "./fsh-generated-renamed/resources/"
def canonicalBase = 'http://jpfhir.jp/fhir/core/'

#ファイルコピー（フォルダチェック付）
def copyFile(src,dest)

  parent = File::dirname(dest)
  if(!Dir.exists?(parent)) then
    FileUtils.mkdir_p(parent)
  end

  p "copy: " + src.to_s + " -> " + dest
  FileUtils.cp(src.to_s, dest)
end

#Resourceファイルを解析し定義URLを取得
def getUrl(fl)
  File.open(fl) do |f|
    hash = JSON.load(f)
    return hash["url"].to_s 
  end
end

#ファイルコピー処理
def copyResource(fl)
  url = getUrl(fl) 
  dest = destDir + url.sub(canonicalBase,"") + ".json"
  copyFile(fl, dest)
end

#ファイル検索対象を指定してコピー
def copyResources(prefix)
    searchPatturn =  srcDir + prefix + "-*.json"
    p "search dir: " + searchPatturn
    files = Dir.glob(searchPatturn)

    for fl in files
      copyResource(fl)
    end
end

# -------------------------------------------------------
# メイン処理（エントリポイント）
# -------------------------------------------------------
begin

  #出力先フォルダの削除
    p "delete dir: " + destDir
  if Dir.exists?(destDir) then
    FileUtils.rm_r(destDir)
  end

  #コピー処理開始
  copyResources("ImplementationGuide")
  copyResources("StructureDefinition")
  copyResources("CapabilityStatement")
  copyResources("SearchParameter")
  #todo valueSet,codeSystemは名前空間が修正待ち
  
end
