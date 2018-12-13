axis([0 101 0 101]);
title('VANET Simulation')
xlabel('Latitude')
ylabel('Longitude')
hold on; 
breadth = 0; 
for length = 0:100
    if(rem(length,10)~=0)
        for breadth = 0:100
            if(rem(breadth,10)~=0)
                h1 = plot(length,breadth,'y');
            end
        end   
    end
    breadth = breadth+1; 
end

%%%%%%%%%%%%creating road network%%%%%%%%%

nodes=4;
pathPoints=5;
pTime=0.1;
pTime2=0.01;
relayCount=6;
nnDistance=10;
nrDistance=25;
rrDistance=50;

[x1,y1] = ginput(pathPoints);
plot(x1,y1,'--ms','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',4)
            
[x2,y2]=ginput(pathPoints);
plot(x2,y2,'--gs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',4)
            
[x3,y3]=ginput(pathPoints);
plot(x3,y3,'--rs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',4)
            
[x4,y4]=ginput(pathPoints);
plot(x4,y4,'--bs','LineWidth',2,...
                'MarkerEdgeColor','b',...
                'MarkerFaceColor','b',...
                'MarkerSize',4)

[p,q]=ginput(relayCount);
relays=zeros(relayCount,3);
for i=1:relayCount
    relays(i,1)=i;
    relays(i,2)=p(i);
    relays(i,3)=q(i);
    plot(p(i),q(i),'*k');
    text(p(i),q(i)+3,strcat('RSU',num2str(i),'   '),'HorizontalAlignment','center');
end

rrSegment=[0,0,0];
count=0;
for i=1:relayCount-1
    for j=i+1:relayCount
        if((sqrt((p(j)-p(i))*(p(j)-p(i))+(q(j)-q(i))*(q(j)-q(i))))<=rrDistance)
            count=count+1;
            rrSegment(count,1)=count;
            rrSegment(count,2)=i;
            rrSegment(count,3)=j;
        end
    end
end

for i=1:max(size(rrSegment))
    hh=plot(relays(rrSegment(i,2:3)',2),relays(rrSegment(i,2:3)',3),'k-.','linewidth',1);
end
%legend(hh,'relay-relay connection')

relayData=zeros(4,nodes,relayCount);
for i=1:relayCount
    for j=1:nodes
        relayData(1,j,i)=j;
    end
end

x=[x1,x2,x3,x4];
y=[y1,y2,y3,y4];

xp=[x1(1),x2(1),x3(1),x4(1)];
yp=[y1(1),y2(1),y3(1),y4(1)];
m=[0,0,0,0];

for loop=1:10
    temp_check=zeros(1,4);
    for i=2:pathPoints
        xc=[x1(i),x2(i),x3(i),x4(i)];
        yc=[y1(i),y2(i),y3(i),y4(i)];
        xp=[x1(i-1),x2(i-1),x3(i-1),x4(i-1)];
        yp=[y1(i-1),y2(i-1),y3(i-1),y4(i-1)];
        for j=1:4
            m(j)=floor(sqrt((xp(j)-xc(j))*(xp(j)-xc(j))+(yp(j)-yc(j))*(yp(j)-yc(j))));
        end
        a1=linspace(xp(1),xc(1),m(1));
        b1=linspace(yp(1),yc(1),m(1));
        a2=linspace(xp(2),xc(2),m(2));
        b2=linspace(yp(2),yc(2),m(2));
        a3=linspace(xp(3),xc(3),m(3));
        b3=linspace(yp(3),yc(3),m(3));
        a4=linspace(xp(4),xc(4),m(4));
        b4=linspace(yp(4),yc(4),m(4));
        
        for j=1:max(m)
            if(m(1)>=j)
                h11 = plot(a1(j),b1(j),'*r');
                pj1=[a1(j);b1(j)];
                if(m(2)>=j && norm(pj1-[a2(j);b2(j)])<=nnDistance)
                    h13 = plot([a1(j) a2(j)],[b1(j) b2(j)],'c');
                end
                if(m(3)>=j && norm(pj1-[a3(j);b3(j)])<=nnDistance)
                    h14 = plot([a1(j) a3(j)],[b1(j) b3(j)],'c');
                end
                if(m(4)>=j && norm(pj1-[a4(j);b4(j)])<=nnDistance)
                    h15 = plot([a1(j) a4(j)],[b1(j) b4(j)],'c');
                end
                dt1=zeros(1,relayCount);
                for t=1:relayCount
                    dt1(t)=norm(pj1-[p(t);q(t)]);
                end
                d1=min(dt1);
                t1=find(dt1==d1);
                if(j==1)
                    temp_check(1)=t1;
                end
                if(d1<=nrDistance)
                    h12 = plot([a1(j) p(t1)],[b1(j) q(t1)],'y');
                    relayData(2,1,t1)=1;
                    relayData(3,1,t1)=a1(j);
                    relayData(4,1,t1)=b1(j);
                    if(temp_check(1)~=t1 && j>1)
                        relayData(2,1,temp_check(1))=0;
                    end
                else
                    relayData(2,1,temp_check(1))=0;
                end
                temp_check(1)=t1;
            end
            
            if(m(2)>=j)
                h21 = plot(a2(j),b2(j),'*r');
                pj2=[a2(j);b2(j)];
                if(m(3)>=j && norm(pj2-[a3(j);b3(j)])<=nnDistance)
                    h23 = plot([a2(j) a3(j)],[b2(j) b3(j)],'c');
                end
                if(m(4)>=j && norm(pj2-[a4(j);b4(j)])<=nnDistance)
                    h24 = plot([a2(j) a4(j)],[b2(j) b4(j)],'c');
                end
                dt2=zeros(1,relayCount);
                for t=1:relayCount
                    dt2(t)=norm(pj2-[p(t);q(t)]);
                end
                d2=min(dt2);
                t2=find(dt2==d2);
                if(j==1)
                    temp_check(2)=t2;
                end
                if(d2<=nrDistance)
                    h22 = plot([a2(j) p(t2)],[b2(j) q(t2)],'y');
                    relayData(2,2,t2)=1;
                    relayData(3,2,t2)=a2(j);
                    relayData(4,2,t2)=b2(j);
                    if(temp_check(2)~=t2 && j>1)
                        relayData(2,2,temp_check(2))=0;
                    end
                else
                    relayData(2,2,temp_check(2))=0;
                end
                temp_check(2)=t2;
            end
            
            if(m(3)>=j)
                h31 = plot(a3(j),b3(j),'*r');
                pj3=[a3(j);b3(j)];
                if(m(4)>=j && norm(pj3-[a4(j);b4(j)])<=nnDistance)
                    h33 = plot([a3(j) a4(j)],[b3(j) b4(j)],'c');
                end
                dt3=zeros(1,relayCount);
                for t=1:relayCount
                    dt3(t)=norm(pj3-[p(t);q(t)]);
                end
                d3=min(dt3);
                t3=find(dt3==d3);
                if(j==1)
                    temp_check(3)=t3;
                end
                if(d3<=nrDistance)
                    h32 = plot([a3(j) p(t3)],[b3(j) q(t3)],'y');
                    relayData(2,3,t3)=1;
                    relayData(3,3,t3)=a3(j);
                    relayData(4,3,t3)=b3(j);
                    if(temp_check(3)~=t3 && j>1)
                        relayData(2,3,temp_check(3))=0;
                    end
                else
                    relayData(2,3,temp_check(3))=0;
                end
                temp_check(3)=t3;
            end
            
            if(m(4)>=j)
                h41 = plot(a4(j),b4(j),'*r');
                pj4=[a4(j);b4(j)];
                dt4=zeros(1,relayCount);
                for t=1:relayCount
                    dt4(t)=norm(pj4-[p(t);q(t)]);
                end
                d4=min(dt4);
                t4=find(dt4==d4);
                if(j==1)
                    temp_check(4)=t4;
                end
                if(d4<=nrDistance)
                    h42 = plot([a4(j) p(t4)],[b4(j) q(t4)],'y');
                    relayData(2,4,t4)=1;
                    relayData(3,4,t4)=a4(j);
                    relayData(4,4,t4)=b4(j);
                    if(temp_check(4)~=t4 && j>1)
                        relayData(2,4,temp_check(4))=0;
                    end
                else
                    relayData(2,4,temp_check(4))=0;
                end
                temp_check(4)=t4;
            end
            
            for k=1:relayCount
                for l=1:nodes
                    if(relayData(2,l,k)==0)
                        for a=1:relayCount
                            if(a~=k)
                                if(relayData(2,l,a)==1)
                                    r_connectionPlot_P=[0];
                                    r_connectionPlot_Q=[0];
                                    [shortDistance,shortPath]=shortestPath(relays,rrSegment,k,a);
                                    relayData(3,l,k)=relayData(3,l,a);
                                    relayData(4,l,k)=relayData(4,l,a);
                                    for b = 1:max(size(shortPath))
                                        r_connectionPlot_P(b,1)=relays(shortPath(b),2);
                                        r_connectionPlot_Q(b,1)=relays(shortPath(b),3);
                                    end
                                    hnn=plot(r_connectionPlot_P,r_connectionPlot_Q,'r-.','linewidth',2);
                                    %legend(hnn,'Shortest Path (relay-relay)')
                                    pause(pTime2);
                                    set(hnn,'Visible','off');
                                    break;
                                end
                            end
                        end
                    end
                end
            end
            
            %legend(h12,'node-relay connection')
            %legend(h13,'node-node connection')
            printRii=['NodeID     ';'Status     ';'Latitude   ';'Longitude  '];
            printRdd=relayData(:,:,4);
            [printRii,num2str(printRdd)]
            pause(pTime);
            set(h11,'Visible','off');
            set(h21,'Visible','off');
            set(h31,'Visible','off');
            set(h41,'Visible','off');
            
            %set(h12,'Visible','off');
            %set(h22,'Visible','off');
            %set(h32,'Visible','off');
            %set(h42,'Visible','off');
            %set(h13,'Visible','off');
            %set(h14,'Visible','off');
            %set(h15,'Visible','off');
            %set(h23,'Visible','off');
            %set(h24,'Visible','off');
            %set(h34,'Visible','off');
        end
    end
end