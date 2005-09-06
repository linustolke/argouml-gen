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

import com.jcoverage.coverage.Instrumentation;
import com.jcoverage.coverage.reporting.collation.JavaFileLine;
import com.jcoverage.coverage.reporting.collation.JavaFilePage;
import com.jcoverage.coverage.reporting.collation.PackageSummaryPage;
import com.jcoverage.coverage.reporting.collation.ReportImpl;
import com.jcoverage.coverage.reporting.collation.ReportSummaryPackageLine;
import com.jcoverage.coverage.reporting.collation.ReportSummaryPage;
import com.jcoverage.coverage.reporting.collation.StaticFileCollator;
import com.jcoverage.coverage.reporting.html.MultiViewStaticHtmlFormat;
import com.jcoverage.reporting.Collator;
import com.jcoverage.reporting.FileSerializer;
import com.jcoverage.reporting.Format;
import com.jcoverage.reporting.Line;
import com.jcoverage.reporting.Page;
import com.jcoverage.reporting.Report;
import com.jcoverage.reporting.Serializer;
import com.jcoverage.util.ClassHelper;

import org.apache.log4j.Logger;

import java.io.File;
import java.util.Collection;
import java.util.Iterator;

/**
 * This class take Instrumentation instances and uses them to drive
 * the generation of a report using the <a href="{@docRoot}/com/jcoverage/coverage/reporting/package-summary.html">report framework</a>.
 */
public class ReportDriver {
  private static final Logger logger=Logger.getLogger(ReportDriver.class);

  private Collection javaSourceDirectories;

  private Report report=new ReportImpl();
  private Page indexPage;

  public ReportDriver(Collection javaSourceDirectories) {
    this.javaSourceDirectories=javaSourceDirectories;
    indexPage=report.createFrontPage();
  }

  public synchronized void addInstrumentation(String clzName,Instrumentation instrumentation) {
    if(logger.isDebugEnabled()) {
      logger.debug("clzName: "+clzName);
    }

    if(!isInnerClass(clzName)) {
      String id=getSourceFileId(clzName,instrumentation);

      String packageName=ClassHelper.getPackageName(id);
      if (packageName.equals("")) {
        packageName="default";
      }
      
      // Need to add a package line for this
      Line packageLine=indexPage.lookupLineByField(ReportSummaryPage.CATEGORY_PACKAGE_SUMMARY,ReportSummaryPackageLine.COLUMN_PACKAGE_NAME,packageName);
      Page packageDetailPage=null;
      if(packageLine==null) {
        if(logger.isDebugEnabled()) {
          logger.debug("Creating new line for packagename "+packageName);
        }

        packageLine=indexPage.createLine(ReportSummaryPage.CATEGORY_PACKAGE_SUMMARY);
        packageLine.setField(ReportSummaryPackageLine.COLUMN_PACKAGE_NAME,packageName);
        packageDetailPage=packageLine.openDetailPage();
      } else {
        if(logger.isDebugEnabled()) {
          logger.debug("Found existing line for packagename "+packageName);
        }

        packageDetailPage=packageLine.getDetailPage();
      }

      // Now add the class line
      Line javaFileLine=packageDetailPage.lookupLineByField(PackageSummaryPage.CATEGORY_JAVAFILES,JavaFileLine.COLUMN_FILE_NAME,clzName);
      Page javaFileDetailPage=null;
      if (javaFileLine==null) {
        if(logger.isDebugEnabled()) {
          logger.debug("Creating new line for class "+clzName);
        }

        javaFileLine=packageDetailPage.createLine(PackageSummaryPage.CATEGORY_JAVAFILES);
        javaFileLine.setField(JavaFileLine.COLUMN_FILE_NAME,clzName);
        javaFileLine.setField(JavaFileLine.COLUMN_PATH, resolveSourceFile(id));
        javaFileDetailPage=javaFileLine.openDetailPage();
      } else {
        if(logger.isDebugEnabled()) {
          logger.debug("Found existing line for class "+clzName);
        }

        javaFileDetailPage=javaFileLine.getDetailPage();
      }

      // Add class line to summary
      indexPage.addLineReference(javaFileLine,PackageSummaryPage.CATEGORY_JAVAFILES);
      ((JavaFilePage)javaFileDetailPage).addInstrumentation(instrumentation);
    } // TODO: add else to handle inner class
  }

  public void generate(File outputDir) throws Exception {
    Collator collator=new StaticFileCollator(".html");
    report.setCollator(collator);
    Format htmlFormat=new MultiViewStaticHtmlFormat();
    Serializer serializer=new FileSerializer(outputDir);
    collator.addOutputter(htmlFormat,serializer);
    indexPage.close();
  }

  public static String getSourceFileId(String clzName,Instrumentation instrumentation) {
    if(logger.isDebugEnabled()) {
      logger.debug("clzName: "+clzName);
    }

    if (isInnerClass(clzName)) {
      throw new IllegalStateException("Cannot call this method (getSourceFileId) for an inner class");
    }
    String pkgname=ClassHelper.getPackageName(clzName);
    
    if(logger.isDebugEnabled()) {
      logger.debug("pkgname: "+pkgname);
    }

    if(instrumentation.getSourceFileName()==null) {
      logger.fatal("Incomplete jcoverage.ser instrumentation. Do you need to merge?");
      return clzName;
    }

    if (pkgname.equals("")) {
      return stripJavaSuffix(instrumentation.getSourceFileName());
    } else {
      return pkgname+"."+stripJavaSuffix(instrumentation.getSourceFileName());
    }
  }

  public static String stripJavaSuffix(String s) {
    if(logger.isDebugEnabled()) {
      logger.debug("s: "+s);
    }
    return s.substring(0,s.length()-".java".length());
  }

  public static boolean isInnerClass(String clzName) {
    return clzName.indexOf("$")!=-1;
  }
  /**
   * Given a fully qualified class name, return the absolute path to the
   * source file, looking in each of the source directory trees.
   * 
   * @param id fully qualified class name
   * @return absolute path to source file or an empty string if not resolvable.
   */
  private String resolveSourceFile(String id) {
      Iterator aFile = javaSourceDirectories.iterator();
    while (aFile.hasNext()) {
        File sourceDirectory = (File) aFile.next();
        File possibleResolution =
                new File(sourceDirectory, (id.replace('.', '/') + ".java"));
        if (possibleResolution.exists()) {
            return possibleResolution.getAbsolutePath();
        }
    }
    return "";
  }
}
