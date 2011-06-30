<?php
	$syncday_bin = '/opt/local/bin/mount_sync.sh';
	$syncday_conf = '/opt/local/etc/syncday/';
	$config_list = array(
		'config' => 'Par defaut',
	);
	
	if(isset($_GET['config']) && !empty($_GET['config']))
		system($syncday_bin.' '.$syncday_conf.urlencode(trim($_GET['config'])).'.sh',$retour);
	else
		$retour = false;
?>
<html>
	<head>
		<title>SyncDay - Backup your life</title>
	</head>
	<body>
		<ul>
			<?php foreach($config_list as $file => $name): ?>
				<li>
					<a href="?config=<?php echo $file ?>">Lancer la synchronisation <?php echo $name ?></a>
				</li>
			<?php endforeach ?>
		</ul>
		<?php if($retour): ?>
			<p>
				<pre>
					<?php echo $retour ?>
				</pre>
			</p>
		<?php endif ?>
	</body>
</html>