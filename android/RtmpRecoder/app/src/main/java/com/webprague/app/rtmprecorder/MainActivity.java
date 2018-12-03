package com.webprague.app.rtmprecorder;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.RadioGroup;
import android.widget.Toast;

import butterknife.ButterKnife;
import butterknife.OnClick;
import cn.campusapp.rtmprecorder.R;
import cn.campusapp.rtmprecorder.RecordActivity;

public class MainActivity extends AppCompatActivity {

    private static final String BJ_STREAM_URL = "rtmp://188.131.131.144/live/android";
    private static final String IMU_STREAM_URL = "rtmp://183.175.12.160/live/android";

    @OnClick(R.id.record_btn)
    void onRecordClick(){
        if (radioGroup.getCheckedRadioButtonId() < 0){
            Toast.makeText(MainActivity.this, "请先选择推流服务器地址", Toast.LENGTH_SHORT).show();
        }else {
            if (radioGroup.getCheckedRadioButtonId() == R.id.rb_imu){
                Toast.makeText(MainActivity.this, "已选择服务器：内大", Toast.LENGTH_SHORT).show();
                startActivity(RecordActivity.makeIntent(IMU_STREAM_URL));
            }else {
                if (radioGroup.getCheckedRadioButtonId() == R.id.rb_bj){
                    Toast.makeText(MainActivity.this, "已选择服务器：北京", Toast.LENGTH_SHORT).show();
                    startActivity(RecordActivity.makeIntent(BJ_STREAM_URL));
                }
            }
        }
    }

    private RadioGroup radioGroup;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);
        radioGroup = (RadioGroup) findViewById(R.id.radioGroup);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        menu.add("关于");
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == 0){
            AlertDialog.Builder builder = new  AlertDialog.Builder(this).setTitle("关于").setMessage("作者：内蒙古大学计算机学院 张鹏\n邮箱：zhangpeng@webprague.com").setIcon(R.mipmap.ic_launcher);
            builder.create().show();
        }
        return super.onOptionsItemSelected(item);
    }
}
