#KELibraryの使い方
Podfileに以下を記述  

    pod 'KELibrary', :git => 'git@bitbucket.org:kittengines/kelibrary.git'

使いたいファイルでインポートする

    import KELibrary


##KELoggerの使い方

###コンソール出力
	// 出力先を標準出力にセット
	Logger?.setStream(Logger?.standardOutput)

	Logger?.v("Verbose Log")
    Logger?.d("Debug Log")
    Logger?.i("Info Log")
    Logger?.w("Warning Log")
    Logger?.e("Error Log")

###view出力
    // 出力先をview出力にセット
    Logger?.setStream(Logger?.logViewOutput)

    // 出力先のviewはコレ
    self.view.addSubview(Logger!.logView)

###オプションを変更する

    // 日付
    Logger?.showsDate = true
    // 時間
    Logger?.showsTime = true
    // ファイル名
    Logger?.showsFile = true
    // 関数名
    Logger?.showsFunction = true
    // 引数名
    Logger?.showsArgumentLabel = true
    // 行番号
    Logger?.showsLine = true
    // ログレベル
    Logger?.showsLogLevel = true

    // 日付のフォーマット
    Logger?.dateFormatter = DateFormatter("yyyy-MM-dd")
    // 時間のフォーマット
    Logger?.timeFormatter = DateFormatter("HH:mm:ss")

    // view出力のフォント
    Logger?.logView.logFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)

    // view出力のログヘッダの文字色
    Logger?.logView.headerColor = UIColor.red
    // view出力の各ログレベルの文字色
    Logger?.logView.logColors[LogLevel.Debug] = UIColor.white
    // view出力の背景色
    Logger?.logView.logTextView.backgroundColor = UIColor.black

##便利メソッド集

	// 文字のローカライズ (Localizable.stringsを使う)
	let localizedString = localized("test")

	// ステータスバーの高さ
	let barHeight = StatusBarHeight

	// タブバーの高さ
	let tabHeight = TabBarHeight(self)

	// N秒後にメインスレッドで実行
    dispatchOnMainThreadAfter(5.0) {
    	print("delayed 5 sec")
    }

    // メソッド内で変数のスコープを分ける
    local {
        let a = 10
        print(a)
    }

    // バックグラウンドスレッドで実行
    background {
        print("background!")
    }

    // 保存先のファイルパス
    let path = KEUtility.FileDirectory + "database.plist"

    // このアプリが初めて起動されたかどうか
    if KEUtility.isFirstRun {
        print("welcome!")
    }

    // このバージョンが初めて起動されたかどうか (ビルド番号は関係ない)
    if KEUtility.isFirstRunInVersion {
        print("welcome new version")
    }

    // 最前面に表示されているビューコントローラ
    let presentedController = KEUtility.topViewController

    // C言語的な値を返す代入文 (<-)
    var vc = UIApplication.shared.keyWindow?.rootViewController
    while (vc <- vc?.presentedViewController) != nil {}


    // フォント利用
    UIFont.mplus1pLightFontOfSize(16) // フラットなやつ
    UIFont.awesomeFontOfSize(16) //アイコンみたいなやつ

    // フラットなアラート
    let alert: DOAlertController = DOAlertController(title: nil, message: "Copied", preferredStyle: DOAlertControllerStyle.Alert)
    alert.popoverPresentationController?.sourceView = self.view
            
    alert.addAction(DOAlertAction(title: "OK", style: DOAlertActionStyle.Default, handler: nil))
            
    self.present(alert, animated: true, completion: nil)
