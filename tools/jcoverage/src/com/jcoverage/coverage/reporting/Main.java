/**
 * www.jcoverage.com
 * Copyright (C)2003 jcoverage ltd.
 *
 * This file is part of jcoverage.
 *
 * jcoverage is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation; either version 2 of the License,
 * or (at your option) any later version.
 *
 * jcoverage is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with jcoverage; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 * USA
 *
 */
package com.jcoverage.coverage.reporting;

import gnu.getopt.Getopt;
import gnu.getopt.LongOpt;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.Logger;

import com.jcoverage.coverage.Instrumentation;

public class Main {
  private static final Logger logger=Logger.getLogger(Main.class);

  private static File serializationFile,destDir;

  private static Collection srcDirs = new ArrayList();
  
  public static void main(String[] args) throws Exception {
    LongOpt[] longOpts=new LongOpt[3];
    longOpts[0]=new LongOpt("instrumentation",LongOpt.REQUIRED_ARGUMENT,null,'i');
    longOpts[1]=new LongOpt("output",LongOpt.REQUIRED_ARGUMENT,null,'o');
    longOpts[2]=new LongOpt("source",LongOpt.REQUIRED_ARGUMENT,null,'s');

    Getopt g=new Getopt(Main.class.getName(),args,":i:o:s:",longOpts);

    int c;

    while((c=g.getopt())!=-1) {
      switch(c) {
      case 'i':
        serializationFile=new File(g.getOptarg());

        if (!serializationFile.exists()) {
          throw new Exception("Error: serialization file "+serializationFile+" does not exist");
        }
        if (serializationFile.isDirectory()) {
          throw new Exception("Error: serialization file "+serializationFile+" cannot be a directory");
        }
        break;
      case 'o':
        destDir=new File(g.getOptarg());

        if (destDir.exists() && destDir.isFile()) {
          throw new Exception("Error: destination directory "+destDir+" already exists and is a file");
        }
        destDir.mkdirs();
        break;
      case 's':
        File srcDir=new File(g.getOptarg());

        if (!srcDir.exists()) {
          throw new Exception("Error: source directory "+srcDir+" does not exist");
        }
        if (srcDir.isFile()) {
          throw new Exception("Error: source directory "+srcDir+" should be a directory, not a file");
        }
        srcDirs.add(srcDir);
        break;
      }
    }

    if(logger.isDebugEnabled()) {
      logger.debug("serializationFile is "+serializationFile);
      logger.debug("srcDirs are "+srcDirs);
      logger.debug("destDir is "+destDir);
    }

    // Copy gifs
    File imagesDir=new File(destDir,"images");
    imagesDir.mkdirs();
    copyResource("red.gif",imagesDir);
    copyResource("green.gif",imagesDir);

    ReportDriver driver=new ReportDriver(srcDirs);

    InputStream is=new FileInputStream(serializationFile);
    ObjectInputStream objects=new ObjectInputStream(is);

    for(Iterator it=((Map)objects.readObject()).entrySet().iterator();it.hasNext();) {
      Map.Entry entry=(Map.Entry)it.next();
      driver.addInstrumentation((String)entry.getKey(),(Instrumentation)entry.getValue());
    }

    driver.generate(destDir);
  }

  static String toPackage(String clzName) {
    int i=clzName.lastIndexOf('.');
    if (i==-1) {
      return "default";
    } else {
      return clzName.substring(0,i);
    }
  }

  static byte[] buf=new byte[2^12];

  static void copyResource(String resname,File dir) throws IOException {
    FileOutputStream fos=new FileOutputStream(new File(dir,resname));
    InputStream in=new BufferedInputStream(Main.class.getResourceAsStream(resname));
    while(true) {
      int n=in.read(buf,0,buf.length);
      if (n==-1) {
        break;
      }

      fos.write(buf,0,n);
    }
    in.close();
    fos.close();
  }
}
