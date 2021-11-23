/* drop table classement; */
create table classement (
	 codcls varchar(3) not null
	,libcls varchar(20) not null 
	,numseq smallint not null
	,catage char(1)
	,primary key(codcls)
);
insert into classement (codcls,libcls,numseq,catage) values ('A1','A1',10,0);
insert into classement (codcls,libcls,numseq,catage) values ('A3','A3',14,0);
insert into classement (codcls,libcls,numseq,catage) values ('A2','A2',12,0);
insert into classement (codcls,libcls,numseq,catage) values ('B1','B1',20,0);
insert into classement (codcls,libcls,numseq,catage) values ('B2','B2',22,0);
insert into classement (codcls,libcls,numseq,catage) values ('B3','B3',24,0);
insert into classement (codcls,libcls,numseq,catage) values ('C1','C1',30,0);
insert into classement (codcls,libcls,numseq,catage) values ('C2','C2',32,0);
insert into classement (codcls,libcls,numseq,catage) values ('C3','C3',34,0);
insert into classement (codcls,libcls,numseq,catage) values ('D1','D1',40,0);
insert into classement (codcls,libcls,numseq,catage) values ('D2','D2',42,0);
insert into classement (codcls,libcls,numseq,catage) values ('D3','D3',44,0);
insert into classement (codcls,libcls,numseq,catage) values ('PM','Préminime',100,1);
insert into classement (codcls,libcls,numseq,catage) values ('M','Minime',102,1);
insert into classement (codcls,libcls,numseq,catage) values ('C','Cadet',104,1);
insert into classement (codcls,libcls,numseq,catage) values ('J','Juniors',106,1);
insert into classement (codcls,libcls,numseq,catage) values ('U21','U21',108,1);
insert into classement (codcls,libcls,numseq,catage) values ('S','Senior',110,1);
insert into classement (codcls,libcls,numseq,catage) values ('V','Vétéran',112,1);
create index i01_classement on classement(numseq);

/* drop table catage; */
create table catage (
	 catage varchar(3) not null
	,saison smallint not null
	,inferieur smallint
	,superieur smallint
	,primary key(catage,saison)
);
insert into catage (catage,saison,inferieur,superieur) values ('PM' ,2018,2007,null);
insert into catage (catage,saison,inferieur,superieur) values ('M'  ,2018,2005,2006);
insert into catage (catage,saison,inferieur,superieur) values ('C'  ,2018,2003,2004);
insert into catage (catage,saison,inferieur,superieur) values ('J'  ,2018,2000,2002);
insert into catage (catage,saison,inferieur,superieur) values ('U21',2018,1997,1999);
insert into catage (catage,saison,inferieur,superieur) values ('S'  ,2018,1978,1996);
insert into catage (catage,saison,inferieur,superieur) values ('V'  ,2018,NULL,1977);

/* drop table tournoi; */
create table tournoi (
	 sertrn integer not null
	,saison smallint not null
	,dattrn date not null
	,organisateur varchar(40) not null
	,libelle varchar(60) not null
	,maxcat smallint not null
	,primary key(sertrn)
);
create index i01_tournoi on tournoi (saison);
create index i02_tournoi on tournoi (dattrn);

/* drop table tournoi_categories; */
create table tournoi_categories (
	 sercat integer not null
	,sertrn integer not null
	,saison smallint not null
	,codcat varchar(20) not null
	,heudeb char(5) not null
	,double char(1) not null
	,handicap char(1) not null
	,numset smallint not null 
	,primary key(sercat)
);

/* drop table categories_classement; */
create table categories_classement (
	 sercat integer not null
	,codcls varchar(3) not null
	,catage char(1) not null
	,primary key(sercat,codcls,catage)
);

/* drop table joueur; */
create table joueur (
	 serjou integer not null
	,saison smallint not null
	,licence varchar(8) not null
	,codclb varchar(3) not null
	,nomjou varchar(40) not null
	,codcls varchar(3) not null
	,topcls varchar(3) not null
	,topdem varchar(3) not null
	,datann date
	,catage varchar(3)
	,vrbrgl smallint not null
	,primary key(serjou)	
);
create unique index i01_joueur on joueur (licence,saison);

/* drop table insc; */
create table insc (
	 serinsc integer not null
	,sercat integer not null
	,double char(1) not null
	,serjou integer not null
	,serptn integer
	,statut char(1) not null /* 0=éliminé, 1=qualifié, 9=wo */
	,primary key (serinsc)
);
create index i01_insc on insc (sercat,double,serjou,serptn);

/* drop table tableau; */
create table tableau (
	 sertab integer not null   /* sertab = sercat */
	,taille smallint not null
	,nbrjou smallint not null
	,nbrtds smallint not null
    ,primary key(sertab)
);

/* drop table adv */
create table adv (
	 seradv integer not null
	,serjou integer not null
	,serptn integer not null
	,numseq smallint not null
	,primary key(seradv)
);

/* drop table match; */
create table match (
	 sermtc integer not null
	,sertab integer not null
	,level  smallint not null
	,numseq smallint not null
	,datmtc date not null
	,heure varchar(5)
	,serjo1 integer not null
	,serjo2 integer not null
	,handi1 smallint
	,handi2 smallint
	,score varchar(3)
	,vainqueur integer
	,perdant integer
	,numtbl varchar(3)
	,prochain integer not null
	,stamtc char(1) not null    /* 0=inactif, 1=en-cours, 2=terminé */
	,primary key(sermtc)
);
create index i01_match on match (sertab,level,numseq);
create index i02_match on match (serjo1);
create index i03_match on match (serjo2);

/* drop table result; */
create table result (
	 serres integer not null
	,sermtc integer not null
	,setjo1 smallint not null
	,setjo2 smallint not null
	,stares char(1) not null    /* 0=inactif, 1=en-cours, 2=terminé */
	,primary key (serres)
);
create index i01_result on result (sermtc);

/* drop table game */
create table game (
	 sergam integer not null
	,serres integer not null
	,numseq smallint not null
	,point1 smallint not null
	,point2 smallint not null
	,primary key (sergam)
);
create index i01_game on game(serres);