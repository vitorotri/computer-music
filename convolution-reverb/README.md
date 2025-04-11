# Acoustical Impulse Response Evaluation with Image Sources Method

Pure Data patch for convolution reverb on shoebox rooms. The resulting RIR (Room Impulse Response) is normalized from -1 to 1, and this simplified model will consider an average sound absorption coefficient for the room on a single frequency band.

## The Image Sources Method

Given a shoebox-shaped room with dimensions $L_x$, $L_y$ and $L_z$, in meters, the impulse response is built using the positions of the image sources created from the primary source, where each image source is placed on an image room with index $(i,j,k)$, at position $(i L_x, j L_y, k L_z)$.

For a source at position $(P_x, P_y, P_z) = (S_x, S_y, S_z)$ in room $(0,0,0)$, on the x-axis, the first image source $(i = 1)$ will be at $2 L_x - S_x$, the second one $(i = 2)$ at $2 L_x + S_x$, the third one $(i = 3)$ at $4 L_x - S_x$ and so on. On the opposite direction, for $(i = -1)$, $P_x = -S_x$ and for $(i = -2)$, $P_x = -2 L_x + S_x$. The reasonaning is the same for the other axes. Then, it can be seen that the image sources can be computed with:

$$P_x = 2 L_x \lceil i / 2 \rceil + (-1)^{|i|} S_x,$$
$$P_y = 2 L_y \lceil j / 2 \rceil + (-1)^{|j|} S_y,$$
$$P_z = 2 L_z \lceil k / 2 \rceil + (-1)^{|j|} S_k.$$

The path taken by a single ray from the source until the receiver at position $(O_x, O_y, O_z)$ will be of length $d = |(P_x, P_y, P_z) - (O_x, O_y, O_z)|$, crossing a total of $|i| + |j| + |k|$ walls. The ray's amplitude is also attenuated according to the distance. Consequently, the amplitude of a ray at the receiver is

$$A = \dfrac{(1 - \alpha)^{|i| + |j| + |j|}}{d},$$

where $\alpha$ is the room's average absorption coefficient on a single frequency band. Because the speed of sound $c$ is constant, this ray arrives at the receiver at instant $t = d/c$, in seconds. All that is left is to sum the contribution of each ray arriving at the same instant on a receiver.

The number of virtual rooms / rays will be defined by the desired order of reflection $N$, and it will bound them with the relation

$$|i| + |j| + |k| \leqslant N.$$

To add the absorption of air with index $m$, the amplitude is adapted with

$A *= exp(-md).$

## Requirements and Installation

The external that computes the RIR using Image Sources is in Lua, and it binds with Pd through pd-lua. It alsos uses python and scipy for doing the fft convolution. On Linux, install the requirements with:

	apt-get install puredata pd-lua lua5.2 python3 python3-pip
	
When needed, re-install the correct Lua version required by pd-lua (it will be printed on Pd console when calling the external). Then, with pip:
	
	pip install scipy
	
If necessary, instead of ALSA / Pulseaudio, use the JACK (Jack Audio Connection Kit) server:

	apt-get install jackd2
	
Run the jack server on a terminal before running Pure Data.

Lastly, inside Pd, go to Help -> Find externals -> type in 'command' to install the [command] external (choose latest version), without the quotations, so it runs the python script from Pd.

Place a copy the imgsources.lua file at Pd/externals or the choose the proper path according to your Pure Data install. If the external appears dashed, then it is not properly installed / initialized (it may be necessary only to retype its name).

## Usage

The MAIN.pd file has the main patch. Follow the instructions inside the patch to read an audio file and do the convolution using the scene.txt file. The scene.txt file is...
It will compute the RIR for the left and right ears, convolving it and ...

## License

Please, read the LICENSE file for rights and limitations.

## References

[1] Allen & Berkeley

[2] Queiroz


