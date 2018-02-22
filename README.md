## Network Simulator NS2

> - Discrete event simulator, where the advance of time depends on timing of the events.
> - Used for simulation of wired as well as wireless network functions and protocols (e.g., routing algorithms, TCP, UDP).
> - NS2 consists of two key languages: C++ and Object-oriented Tool Command Language (OTcl).
> - While the C++ defines the internal mechanism (i.e., a backend) of the simulation objects, the OTcl sets up simulation by assembling and configuring the objects as well as scheduling discrete events (i.e., a frontend).
> - C++ is fast to run but slow to change. It is suitable for running a large simulation. 
> - OTcl is slow to run but fast to change. It is therefore suitable to run a small simulation over several repetitions.
> - Use OTcl
>   - for configuration, setup, or one time simulation, or
>   - to run simulation with existing NS2 modules.    
> - Use C++
>   - when you are dealing with a packet, or    
>   - when you need to modify existing NS2 modules.
> - "ns" is a C++ executable file obtained from the compilation,

**Basic Architecture of NS2**
<p align=center>
  <img src="Figures/NS-Architecture.png" />
</p>  

**NS2 Directory**
<p align=center>
  <img src="Figures/NS-Directory.png" />
</p>
