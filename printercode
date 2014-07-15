using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    public class Point3D
    {
        public int X;
        public int Y;
        public int Z;
        public void setPoint3D(List<Point3D> a, int x,int y,int z, Point3D p)
        {
            p.X = x;
            p.Y = y;
            p.Z = z;
            a.Add(p);
        }
    }
    public class Object3D
    {
        private void Print(int x, int y)
        {
            Console.WriteLine(x + ", " + y);
        }
        public void printObject3D(List<Point3D> a)
        {
            while (a.Count > 0)
            {
                foreach (Point3D p in a.Where(x=>x.Z!=0))
                {
                    Print(p.X, p.Y);
                    p.Z--;
                }
            }
        }
    }
    class Program
    {
        static void Main(string[] args)
        {
            List<Point3D> points = new List<Point3D>();
            Point3D point = new Point3D();
            point.setPoint3D(points, 1, 2, 3, point);
            Object3D obj = new Object3D();
            obj.printObject3D(points);
        }
    }
}
