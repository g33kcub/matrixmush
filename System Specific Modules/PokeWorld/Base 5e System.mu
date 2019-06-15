@create Pokemon Functions <PokeF>
@set pokef=NO_MODIFY INDESTRUCTIBLE SAFE SIDEFX INHERIT
@parent pokef=[u(cobj,bbk)]
@fo me=&cobj`pokef bbk=[objid(pokef)]
&start`function`pokemon [u(cobj,start)]=@function/privileged pokemon=[u(cobj,pokef)]/pokemon_name_fmt
&pokemon_name_fmt [u(cobj,pokef)]=[accent(Pokemon,Pok'mon)]
