# Image Sources Compute

Pure Data patch for convolution reverb on shoebox rooms.

## The Image Sources Method

Given a shoebox-shaped room with dimensions $L_x$, $L_y$ and $L_z$, in meters, the impulse response is built using the positions of the image sources created from the primary source, where each image source is placed on a image room with position $(i * L_x, j * L_y, k * L_z)$.
Each reflection 

## Requirements and Installation

The external that computes the RIR (Room Impulse Response) using Image Sources is in Lua, and it binds with Pd through pd-lua. It alsos uses python and scipy for doing the fft convolution. On Linux, install the requirements with:

	$ apt-get install puredata pd-lua jackd2 lua5.2 python3 python3-pip
	
	$ pip install scipy
	
Select the correct Lua version required by pd-lua (it will be printed on Pd console when calling the external). If necessary, instead of ALSA / Pulseaudio, use the JACK (Jack Audio Connection Kit) server:

	$ apt-get install jackd2
	
Run the jack server on a terminal before running Pure Data.

lastly, inside Pd, go to Help -> Find externals -> type in 'command' to install the [command] external (choose latest version), without the quotations, so it runs the python script from Pd.

Place a copy the imgsources.lua file at Pd/externals or the choose the proper path according to your Pure Data install. If the external appears dashed, then it is not properly installed / initialized (it may be necessary only to retype its name).

## Usage

The MAIN.pd file has the main patch.

## References

...


