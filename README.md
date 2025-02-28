# Tutorial 2 - Game Development

Nama: Fikri Risyad Indratno<br>
NPM: 2206031170

## Latihan Mandiri: Eksplorasi Mekanika Pergerakan

### Double Jump
Saya telah mengimplementasikan *double jump* dengan menambahkan variabel `can_double_jump` untuk membatasi *player* sehingga hanya bisa melakukan satu lompatan tambahan. Dengan mengkombinasikan variabel ini dengan `not is_on_floor()` atau *player* sedang tidak menyentuh tanah, *player* dapat melakukan lompatan satu kali lagi dan mengubah nilai `can_double_jump` menjadi `false`. Variabel ini akan bernilai `true` ketika *player* sedang berada di atas lantai dan akan bernilai `false` jika player telah melakukan lompatan kedua.

```
...
var can_double_jump = true
...

func _physics_process(delta: float) -> void:
	velocity.y += delta * gravity
	handle_jump()
    ...

func handle_jump() -> void:
    if is_on_floor():
        if Input.is_action_just_pressed('ui_up'):
            velocity.y = jump_speed
        can_double_jump = true
    elif can_double_jump and Input.is_action_just_pressed('ui_up'):
        velocity.y = jump_speed
        can_double_jump = false
```

### Dash
Saya telah mengimplementasikan *dash* dengan pertama-tama menambahkan variabel di bawah ini: 
```
...
@export var dash_speed: float = 900.0
@export var dash_duration: float = 0.2
@export var dash_press_interval: float = 0.2
...
var last_left_press_time: float = 0.0
var last_right_press_time: float = 0.0
```

`dash_speed` menentukan seberapa cepat kita *dash*, `dash_duration` menentukan seberapa lama *dash* berlangsung, `dash_press_interval` menentukan batas interval *player* untuk melakukan *double press key* kiri atau kanan, lalu variabel `last_left_press_time` dan `last_right_press_time` menentukan waktu terakhir kali *key* tersebut ditekan.

Saya mengawali dengan `if dashing` *guard* agar *player* tidak dapat *dash* jika sedang melakukan *dash*. Lalu, saya menyimpan waktu sekarang di dalam `current_time` yang nantinya akan dikurangi dengan `last_left_press_time` atau `last_right_press_time`, sesuai dengan *key* yang ditekan, dan akan dibandingkan dengan `dash_press_interval`. Jika kurang dari `dash_press_interval`, maka `direction` akan dimasukkan nilai sesuai dengan arah. Lalu, variabel `last_left_press_time` atau `last_right_press_time` akan di-*update* dengan `current_time`. Jika `direction != 0`, *player* akan melakukan *dash* selama `dash_duration`.

```
func _physics_process(delta: float) -> void:
	velocity.y += delta * gravity
	handle_jump()
	handle_dash()
    ...

func handle_dash() -> void:
	if dashing:
		return

	var current_time = Time.get_ticks_msec() / 1000.0
	var direction = 0
	
	if Input.is_action_just_pressed("ui_left"):
		if current_time - last_left_press_time < dash_press_interval:
			direction = -1
		last_left_press_time = current_time

	if Input.is_action_just_pressed("ui_right"):
		if current_time - last_right_press_time < dash_press_interval:
			direction = 1
		last_right_press_time = current_time
	
	if direction != 0:
		start_dash(direction)

func start_dash(direction: int) -> void:
	dashing = true
	velocity.x = direction * dash_speed

	# Stop dash after a short time
	await get_tree().create_timer(dash_duration).timeout
	dashing = false
```

### Referensi
- [Double jump](https://forum.godotengine.org/t/how-to-double-jump/4562#:~:text=Something%20like%2C%20can_doublejump)
- [Dash](https://www.youtube.com/watch?v=GpLy_e1s14A)