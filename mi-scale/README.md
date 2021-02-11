# Xiaomi Mi Scale Add On for Home Assistant

Add-On for [HomeAssistant](https://www.home-assistant.io/) to read weight measurements from Xiaomi Body Scales.

## Supported Scales:
Name | Model | Picture
--- | --- | :---:
[Mi Smart Scale 2](https://www.mi.com/global/scale) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | XMTZC04HM | ![Mi Scale_2](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/Mi_Smart_Scale_2_Thumb.png)
[Mi Body Composition Scale](https://www.mi.com/global/mi-body-composition-scale/) | XMTZC02HM | ![Mi Scale](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/Mi_Body_Composition_Scale_Thumb.png)
[Mi Body Composition Scale 2](https://c.mi.com/thread-2289389-1-0.html) | XMTZC05HM | ![Mi Body Composition Scale 2](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/Mi_Body_Composition_Scale_2_Thumb.png)


## Setup

1. Retrieve the scale's MAC Address from the Xiaomi Mi Fit App:

![MAC Address](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/MAC_Address.png)

2. Open Home Assistant and navigate to add-on store. Click on the 3 dots (top right) and select Repositories
3. Enter `https://github.com/lolouk44/hassio-addons` in the box and click on Add
4. You should now see Lolouk44 Add-Ons at the bottom list:
5. Click on Xiaomi Mi Scale then click on Install
6. Edit the Configuration


Option | Type | Required | Description
--- | --- | --- | ---
HCI_DEV | string | No | Bluetooth hci device to use. Defaults to hci0
BLUEPY_PASSIVE_SCAN | bool | No | Try to set to true if getting an error like `Bluetooth connection error: Failed to execute management command ‘le on’` on a Raspberry Pi. Defaults to false
MISCALE_MAC | string | Yes | Mac address of your scale
MQTT_PREFIX | string | No | MQTT Topic Prefix. Defaults to miscale
MQTT_HOST | string | Yes | MQTT Server (defaults to 127.0.0.1)
MQTT_USERNAME | string | No | Username for MQTT server (comment out if not required)
MQTT_PASSWORD | string | No | Password for MQTT (comment out if not required)
MQTT_PORT | int | No | Defaults to 1883
TIME_INTERVAL | int | No | Time in sec between each query to the scale, to allow other applications to use the Bluetooth module. Defaults to 30
MQTT_DISCOVERY | bool | No | MQTT Discovery for Home Assistant Defaults to true
MQTT_DISCOVERY_PREFIX | string | No | MQTT Discovery Prefix for Home Assistant. Defaults to homeassistant
USERS | List | Yes | List of users to add

Auto-gender selection/config -- This is used to create the calculations such as BMI, Water/Bone Mass etc...
Here is the logic used to assign a measured weight to a user:
```
if [measured value in kg] is within the range of a user's defined values for GT and LT then it will match to that user.
If the weight matches two separate user's ranges, it will just be assigned to the first user that matched (so don't overlap ranges!)
```

User Option | Type | Required | Description
--- | --- | --- | ---
GT | int | Yes | Greater Than - Weight (in kg) must be greater than this value - this will be the lower limit for the weight range of this user
LT | int | Yes | Less Than - Weight (in kg) must be less than this value - this will be the upper limit for the weight range of this user
SEX | string | Yes | male / female
NAME | string | Yes | Name of the user
HEIGHT | int | Yes | Height (in cm) of the user
DOB | string | Yes | DOB (in yyyy-mm-dd format)

7. Start the add-on


## Home-Assistant Setup:
Under the `sensor` block, enter as many blocks as users configured in your environment variables:
(Note: only weight entities are automatically added via the MQTT Discovery)

```yaml
  - platform: mqtt
    name: "Example Name Weight"
    state_topic: "miscale/USER_NAME/weight"
    value_template: "{{ value_json['weight'] }}"
    unit_of_measurement: "kg"
    json_attributes_topic: "miscale/USER_NAME/weight"
    icon: mdi:scale-bathroom

  - platform: mqtt
    name: "Example Name BMI"
    state_topic: "miscale/USER_NAME/weight"
    value_template: "{{ value_json['bmi'] }}"
    icon: mdi:human-pregnant
    unit_of_measurement: "kg/m2"

```

![Mi Scale](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/HA_Lovelace_Card.png)

![Mi Scale](https://raw.githubusercontent.com/lolouk44/xiaomi_mi_scale/master/Screenshots/HA_Lovelace_Card_Details.png)

## Acknowledgements:
Thanks to @syssi (https://gist.github.com/syssi/4108a54877406dc231d95514e538bde9) and @prototux (https://github.com/wiecosystem/Bluetooth) for their initial code

Special thanks to [@ned-kelly](https://github.com/ned-kelly) for his help turning a "simple" python script into a fully fledged docker container

Thanks to [@bpaulin](https://github.com/bpaulin), [@fabir-git](https://github.com/fabir-git)for their PRs and collaboration
