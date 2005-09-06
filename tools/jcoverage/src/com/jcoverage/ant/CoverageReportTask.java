/*
 * The Apache Software License, Version 1.1
 *
 * Copyright (c) 2000-2002 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution, if
 *    any, must include the following acknowlegement:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowlegement may appear in the software itself,
 *    if and wherever such third-party acknowlegements normally appear.
 *
 * 4. The names "Ant" and "Apache Software
 *    Foundation" must not be used to endorse or promote products derived
 *    from this software without prior written permission. For written
 *    permission, please contact apache@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache"
 *    nor may "Apache" appear in their names without prior written
 *    permission of the Apache Group.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */
package com.jcoverage.ant;

import com.jcoverage.coverage.Version;

import java.io.File;

import java.net.URLClassLoader;
import java.net.URL;

import org.apache.tools.ant.AntClassLoader;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Java;
import org.apache.tools.ant.taskdefs.MatchingTask;
import org.apache.tools.ant.types.Path;
import org.apache.tools.ant.types.Reference;

public class CoverageReportTask extends MatchingTask {
  private Path src;
  private Java java=null;
  private File destDir;
  private String format="html";
  private Instrumentation serializedInstrumentation=new Instrumentation();

  private Java getJava() {
    if(java==null) {
      java=(Java)getProject().createTask("java");
      java.setTaskName(getTaskName());
      java.setFork(true);
      java.setDir(getProject().getBaseDir());

      if(getClass().getClassLoader() instanceof AntClassLoader) {
        createClasspath().setPath(((AntClassLoader)getClass().getClassLoader()).getClasspath());
      } else if(getClass().getClassLoader() instanceof URLClassLoader) {
        URL[] earls=((URLClassLoader)getClass().getClassLoader()).getURLs();
        for(int i=0;i<earls.length;i++) {
          createClasspath().setPath(earls[i].getFile());
        }
      }
    }
    return java;
  }

  public Path createClasspath() {
    return getJava().createClasspath().createPath();
  }

  public void setClasspath(Path classpath) {
    createClasspath().append(classpath);
  }

  public void setClasspathRef(Reference r) {
    createClasspath().setRefid(r);
  }

  public void setFormat(String format) {
    this.format=format;
  }

  public void execute() throws BuildException {
    System.out.println("jcoverage "+Version.VERSION_STRING+" copyright (c)2003 jcoverage ltd. http://jcoverage.com/");
    System.out.println("jcoverage is licensed under the GNU General Public License");
    System.out.println("jcoverage comes with ABSOLUTELY NO WARRANTY");

    if(format.equalsIgnoreCase("xml")) {
      getJava().setClassname(ReportFormat.XML);
    } else {
      getJava().setClassname(ReportFormat.HTML);
    }

    getJava().createArg().setValue("-i");
    getJava().createArg().setValue(serializedInstrumentation.getFile());

    String[] srcDirs = getSrc().list();
    for (int i = 0; i < srcDirs.length; i++) {
        getJava().createArg().setValue("-s");
        getJava().createArg().setValue(srcDirs[i]);
    }

    getJava().createArg().setValue("-o");
    getJava().createArg().setValue(destDir.toString());

    if(getJava().executeJava()!=0) {
      throw new BuildException();
    }
  }

  public Instrumentation createInstrumentation() {
    return serializedInstrumentation;
  }

  /**
   * Can use a single srcDir attribute and/or a nested src element.
   *  
   * @param srcDir
   */
  public void setSrcdir(Path srcDir) {
    if(src==null) {
      src=srcDir;
    } else {
      src.append(srcDir);
    }
  }

  public Path getSrcdir() {
    return src;
  }

  public void setDestdir(File destDir) {
    this.destDir=destDir;
  }

  /**
   * Can use a single srcDir attribute and/or a nested src element.
   * @return new child Src path element.
   */
  public Path createSrc() {
      return getSrc().createPath();
  }
  
  /**
   * Lazy initialize the child src path element.
   * @return src path.
   */
  private Path getSrc() {
    if (src == null) {
      src = new Path(getProject());
    }
    return src;
  }
    
  public File getDestdir() {
    return destDir;
  }

}
