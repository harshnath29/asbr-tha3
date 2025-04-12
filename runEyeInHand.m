[q_Robot_config, q_camera_config,t_Robot_config,t_camera_config ]=data_quaternion();
[R, p] = eyeInHand(q_Robot_config, t_Robot_config, q_camera_config, t_camera_config)

[q_Robot_config, q_camera_config,t_Robot_config,t_camera_config ]=data_quaternion_noisy();
[R, p] = eyeInHand(q_Robot_config, t_Robot_config, q_camera_config, t_camera_config)