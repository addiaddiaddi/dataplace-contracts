import json

# Sample data
data = {
    "name": "John",
    "age": 30,
    "city": "New York"
}


data = {
"a": 3
}

data =[{"interval":["2023-08-22T00:00:00.000000+01:00","2023-08-23T00:00:00.000000+01:00"],"activity_seconds":23844,"inactivity_seconds":62256,"vigorous_intensity_seconds":60,"BMR_calories":1495,"net_activity_calories":716,"total_burned_calories":2211,"distance_meters":14075,"steps":19914,"avg_hr_bpm":88.8148148148,"max_hr_bpm":120,"min_hr_bpm":62,"resting_hr_bpm":57,"avg_saturation_percentage":96.8846153846,"activity_stress_duration_seconds":24060,"avg_stress_level":66,"high_stress_duration_seconds":9420,"low_stress_duration_seconds":6660,"max_stress_level":96,"medium_stress_duration_seconds":15180,"rest_stress_duration_seconds":60,"stress_duration_seconds":31260},{"interval":["2023-08-23T00:00:00.000000+01:00","2023-08-24T00:00:00.000000+01:00"],"activity_seconds":24663,"inactivity_seconds":61737,"vigorous_intensity_seconds":240,"BMR_calories":1495,"net_activity_calories":1134,"total_burned_calories":2629,"distance_meters":14617,"steps":20709,"avg_hr_bpm":84.2677916361,"max_hr_bpm":142,"min_hr_bpm":51,"resting_hr_bpm":54,"avg_saturation_percentage":92.3,"activity_stress_duration_seconds":33660,"avg_stress_level":37,"high_stress_duration_seconds":12120,"low_stress_duration_seconds":1140,"max_stress_level":97,"medium_stress_duration_seconds":6480,"rest_stress_duration_seconds":28200,"stress_duration_seconds":19740},{"interval":["2023-08-24T00:00:00.000000+01:00","2023-08-25T00:00:00.000000+01:00"],"activity_seconds":14203,"inactivity_seconds":72197,"vigorous_intensity_seconds":1020,"BMR_calories":1495,"net_activity_calories":780,"total_burned_calories":2275,"distance_meters":14143,"steps":18696,"avg_hr_bpm":91.1820448878,"max_hr_bpm":178,"min_hr_bpm":59,"resting_hr_bpm":58,"avg_saturation_percentage":92.7875,"activity_stress_duration_seconds":15420,"avg_stress_level":66,"high_stress_duration_seconds":11160,"low_stress_duration_seconds":6960,"max_stress_level":97,"medium_stress_duration_seconds":8700,"rest_stress_duration_seconds":300,"stress_duration_seconds":26820},{"interval":["2023-08-25T00:00:00.000000+01:00","2023-08-26T00:00:00.000000+01:00"],"activity_seconds":21439,"inactivity_seconds":64961,"vigorous_intensity_seconds":1140,"BMR_calories":1260,"net_activity_calories":928,"total_burned_calories":2423,"distance_meters":17176,"steps":22637,"avg_hr_bpm":78.5789839944,"max_hr_bpm":162,"min_hr_bpm":49,"resting_hr_bpm":51,"avg_saturation_percentage":92.9653379549,"activity_stress_duration_seconds":21060,"avg_stress_level":38,"high_stress_duration_seconds":9600,"low_stress_duration_seconds":6780,"max_stress_level":99,"medium_stress_duration_seconds":11100,"rest_stress_duration_seconds":28020,"stress_duration_seconds":27480},{"interval":["2023-08-26T00:00:00.000000+03:00","2023-08-27T00:00:00.000000+03:00"],"activity_seconds":360,"inactivity_seconds":15240,"vigorous_intensity_seconds":60,"BMR_calories":269,"net_activity_calories":240,"total_burned_calories":269,"distance_meters":8,"steps":12,"avg_hr_bpm":63.25,"max_hr_bpm":97,"min_hr_bpm":55,"resting_hr_bpm":57,"avg_saturation_percentage":93.1437007874,"activity_stress_duration_seconds":420,"avg_stress_level":19,"high_stress_duration_seconds":60,"low_stress_duration_seconds":2460,"max_stress_level":78,"medium_stress_duration_seconds":540,"rest_stress_duration_seconds":10200,"stress_duration_seconds":3060},{"interval":["2023-08-27T00:00:00.000000+03:00","2023-08-28T00:00:00.000000+03:00"],"activity_seconds":11899,"inactivity_seconds":74501,"vigorous_intensity_seconds":1080,"BMR_calories":840,"net_activity_calories":1495,"total_burned_calories":448,"distance_meters":1943,"steps":7413,"avg_hr_bpm":72.2126582278,"max_hr_bpm":179,"min_hr_bpm":47,"resting_hr_bpm":48,"avg_saturation_percentage":94.2,"activity_stress_duration_seconds":10680,"avg_stress_level":10680,"high_stress_duration_seconds":32,"low_stress_duration_seconds":7620,"max_stress_level":96,"medium_stress_duration_seconds":13260,"rest_stress_duration_seconds":27600,"stress_duration_seconds":26280}]

# Serialize JSON to string
json_string = json.dumps(data)

# Convert the string to bytes
byte_representation = json_string.encode('utf-8')

print(byte_representation)
print(byte_representation.hex())
